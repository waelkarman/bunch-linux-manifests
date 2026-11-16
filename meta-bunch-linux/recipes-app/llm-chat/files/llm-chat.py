"""Chat con il modello linguistico locale (llama-server) in una finestra GTK3.

Parla con llama-server tramite l'API compatibile OpenAI (/v1/chat/completions)
e mostra la risposta mentre viene generata (streaming). Nessuna dipendenza
oltre a Python3 e PyGObject: HTTP con urllib.

Uso:
    llm-chat                              # server da /etc/default/llama-server
    llm-chat --url http://127.0.0.1:8080  # altro server
    llm-chat --fullscreen

Tasti: Invio = invia, Esc = ferma la risposta, Ctrl+N = nuova chat, Ctrl+Q = esci.
"""
import argparse
import json
import threading
import time
import urllib.error
import urllib.request

import gi

gi.require_version("Gtk", "3.0")
gi.require_version("Gdk", "3.0")
from gi.repository import Gdk, GLib, Gtk, Pango  # noqa: E402

CONFIG = "/etc/default/llama-server"
SYSTEM_PROMPT = (
    "Sei l'assistente di Bunch Linux, un sistema operativo per Raspberry Pi. "
    "Rispondi in italiano, in modo breve e chiaro, salvo richieste diverse."
)
# Messaggi della conversazione inviati al modello (oltre al prompt di sistema):
# i più vecchi escono, così la richiesta resta nel contesto di llama-server.
MAX_MESSAGGI = 16
MAX_TOKEN_RISPOSTA = 512

CSS = b"""
#stato { padding: 4px 8px; }
#chat text { background-color: #fafafa; }
#chat { font-size: 13pt; }
"""


def url_da_config(percorso: str = CONFIG) -> str:
    """Indirizzo di llama-server letto dal suo file di configurazione."""
    valori = {"LLAMA_ARG_HOST": "127.0.0.1", "LLAMA_ARG_PORT": "8080"}
    try:
        with open(percorso, encoding="utf-8") as f:
            for riga in f:
                chiave, sep, valore = riga.strip().partition("=")
                if sep and chiave in valori and valore:
                    valori[chiave] = valore.strip().strip("\"'")
    except OSError:
        pass
    host = valori["LLAMA_ARG_HOST"].split(",")[0]
    if host in ("0.0.0.0", "::", ""):
        host = "127.0.0.1"
    if ":" in host:  # IPv6
        host = f"[{host}]"
    return f"http://{host}:{valori['LLAMA_ARG_PORT']}"


class Chat(Gtk.Window):
    def __init__(self, url: str):
        super().__init__(title="Assistente")
        self.url = url.rstrip("/")
        self.messaggi: list[dict] = []
        self.stop = threading.Event()
        self.in_corso = False
        self.risposta = None  # risposta HTTP in lettura (per interromperla)
        self.sessione = 0  # cambia con "Nuova chat": scarta le risposte della chat precedente

        self.set_default_size(760, 560)
        self.connect("destroy", Gtk.main_quit)
        self.connect("key-press-event", self.on_tasto)

        provider = Gtk.CssProvider()
        provider.load_from_data(CSS)
        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6, margin=8)
        self.add(box)

        # Barra in alto: stato del server e nuova chat
        barra = Gtk.Box(spacing=6)
        self.stato = Gtk.Label(label="Connessione…", xalign=0, name="stato")
        self.stato.set_ellipsize(Pango.EllipsizeMode.END)
        nuova = Gtk.Button(label="Nuova chat")
        nuova.connect("clicked", lambda *_: self.nuova_chat())
        barra.pack_start(self.stato, True, True, 0)
        barra.pack_end(nuova, False, False, 0)
        box.pack_start(barra, False, False, 0)

        # Conversazione
        self.testo = Gtk.TextView(name="chat", editable=False, cursor_visible=False,
                                  wrap_mode=Gtk.WrapMode.WORD_CHAR,
                                  left_margin=10, right_margin=10,
                                  top_margin=8, bottom_margin=8)
        self.buf = self.testo.get_buffer()
        self.buf.create_tag("utente", weight=Pango.Weight.BOLD, foreground="#1565c0",
                            pixels_above_lines=10)
        self.buf.create_tag("assistente", foreground="#212121", pixels_above_lines=4)
        self.buf.create_tag("info", foreground="#757575", style=Pango.Style.ITALIC,
                            scale=0.85)
        self.buf.create_tag("errore", foreground="#c62828")
        self.fine = self.buf.create_mark("fine", self.buf.get_end_iter(), False)
        scroll = Gtk.ScrolledWindow(hscrollbar_policy=Gtk.PolicyType.NEVER)
        scroll.add(self.testo)
        box.pack_start(scroll, True, True, 0)

        # Riga di inserimento
        riga = Gtk.Box(spacing=6)
        self.entry = Gtk.Entry(placeholder_text="Scrivi un messaggio e premi Invio")
        self.entry.connect("activate", lambda *_: self.invia())
        self.pulsante = Gtk.Button(label="Invia")
        self.pulsante.connect("clicked", lambda *_: self.ferma() if self.in_corso else self.invia())
        riga.pack_start(self.entry, True, True, 0)
        riga.pack_end(self.pulsante, False, False, 0)
        box.pack_start(riga, False, False, 0)

        self.nuova_chat()
        threading.Thread(target=self.controlla_server, daemon=True).start()

    # --- interfaccia ---------------------------------------------------------

    def scrivi(self, testo: str, tag: str):
        self.buf.insert_with_tags_by_name(self.buf.get_end_iter(), testo, tag)
        self.testo.scroll_mark_onscreen(self.fine)
        return False  # per GLib.idle_add

    def imposta_stato(self, testo: str):
        self.stato.set_text(testo)
        return False

    def nuova_chat(self):
        self.ferma()
        self.sessione += 1
        self.messaggi.clear()
        self.buf.set_text("")
        self.scrivi("Modello linguistico locale: tutto resta su questo dispositivo.\n", "info")
        self.entry.grab_focus()

    def on_tasto(self, _w, ev):
        ctrl = ev.state & Gdk.ModifierType.CONTROL_MASK
        if ev.keyval == Gdk.KEY_Escape:
            self.ferma()
        elif ctrl and ev.keyval in (Gdk.KEY_n, Gdk.KEY_N):
            self.nuova_chat()
        elif ctrl and ev.keyval in (Gdk.KEY_q, Gdk.KEY_Q):
            self.destroy()
        else:
            return False
        return True

    def occupato(self, si: bool):
        self.in_corso = si
        self.pulsante.set_label("Ferma" if si else "Invia")
        self.entry.set_sensitive(not si)
        if not si:
            self.entry.grab_focus()
        return False

    # --- server --------------------------------------------------------------

    def controlla_server(self):
        """Ogni 3 s: il modello è caricato? (/health risponde 503 durante il caricamento)."""
        while True:
            if not self.in_corso:
                try:
                    with urllib.request.urlopen(self.url + "/health", timeout=2):
                        stato = "● Pronto"
                except urllib.error.HTTPError as e:
                    stato = "◌ Caricamento del modello…" if e.code == 503 else f"✕ Errore {e.code}"
                except (urllib.error.URLError, OSError):
                    stato = f"✕ llama-server non raggiungibile ({self.url})"
                GLib.idle_add(self.imposta_stato, stato)
            time.sleep(3)

    def invia(self):
        domanda = self.entry.get_text().strip()
        if not domanda or self.in_corso:
            return
        self.entry.set_text("")
        self.messaggi.append({"role": "user", "content": domanda})
        del self.messaggi[:-MAX_MESSAGGI]
        self.scrivi(f"\nTu: {domanda}\n", "utente")
        self.occupato(True)
        self.stop.clear()
        threading.Thread(target=self.genera, args=(list(self.messaggi), self.sessione),
                         daemon=True).start()

    def ferma(self):
        """Chiude la connessione: llama-server interrompe la generazione."""
        self.stop.set()
        r = self.risposta
        if r is not None:
            try:
                r.close()
            except Exception:
                pass

    def scrivi_se(self, sessione: int, testo: str, tag: str):
        """Scrive solo se la chat è ancora quella della domanda."""
        if sessione == self.sessione:
            self.scrivi(testo, tag)
        return False

    def genera(self, messaggi: list[dict], sessione: int):
        corpo = {
            "messages": [{"role": "system", "content": SYSTEM_PROMPT}, *messaggi],
            "stream": True,
            "max_tokens": MAX_TOKEN_RISPOSTA,
            "temperature": 0.7,
        }
        req = urllib.request.Request(
            self.url + "/v1/chat/completions", data=json.dumps(corpo).encode(),
            headers={"Content-Type": "application/json"})
        testo, timings, inizio = [], None, time.monotonic()
        GLib.idle_add(self.imposta_stato, "… Elaborazione della domanda")
        try:
            # timeout lungo: sul Pi la prima risposta può richiedere decine di secondi
            self.risposta = urllib.request.urlopen(req, timeout=600)
            for riga in self.risposta:
                if self.stop.is_set():
                    break
                riga = riga.strip()
                if not riga.startswith(b"data:"):
                    continue
                dati = riga[5:].strip()
                if dati == b"[DONE]":
                    break
                pezzo = json.loads(dati)
                timings = pezzo.get("timings") or timings
                for scelta in pezzo.get("choices") or []:
                    contenuto = (scelta.get("delta") or {}).get("content")
                    if contenuto:
                        if not testo:
                            GLib.idle_add(self.scrivi_se, sessione, "", "assistente")
                            GLib.idle_add(self.imposta_stato, "● Risposta in corso…")
                        testo.append(contenuto)
                        GLib.idle_add(self.scrivi_se, sessione, contenuto, "assistente")
        except urllib.error.HTTPError as e:
            messaggio = e.read().decode(errors="replace")[:300]
            if e.code == 503:
                messaggio = "il modello è ancora in caricamento, riprova tra poco."
            GLib.idle_add(self.scrivi_se, sessione, f"\nErrore {e.code}: {messaggio}\n", "errore")
        except Exception as e:  # anche la connessione chiusa da ferma() durante la lettura
            if not self.stop.is_set():
                GLib.idle_add(self.scrivi_se, sessione, f"\nErrore di connessione: {e}\n", "errore")
        finally:
            self.risposta = None

        risposta = "".join(testo)
        if sessione == self.sessione:
            if risposta:
                self.messaggi.append({"role": "assistant", "content": risposta})
            elif self.messaggi and self.messaggi[-1] is messaggi[-1]:
                self.messaggi.pop()  # domanda senza risposta: non resta nella cronologia

        if self.stop.is_set():
            info = "\n[interrotta]\n"
        elif timings and timings.get("predicted_per_second"):
            info = (f"\n{timings.get('predicted_n', 0)} token, "
                    f"{timings['predicted_per_second']:.1f} token/s\n")
        elif risposta:
            info = f"\n{time.monotonic() - inizio:.0f} s\n"
        else:
            info = ""
        if info:
            GLib.idle_add(self.scrivi_se, sessione, info, "info")
        GLib.idle_add(self.imposta_stato, "● Pronto")
        GLib.idle_add(self.occupato, False)


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--url", default=None, help=f"indirizzo di llama-server (default: da {CONFIG})")
    ap.add_argument("--fullscreen", action="store_true", help="finestra a schermo intero")
    args = ap.parse_args()

    win = Chat(args.url or url_da_config())
    if args.fullscreen:
        win.fullscreen()
    win.show_all()
    Gtk.main()


if __name__ == "__main__":
    main()
