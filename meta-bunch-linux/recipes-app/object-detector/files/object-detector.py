"""Apre la telecamera e riconosce in tempo reale gli oggetti inquadrati (YOLO11, 80 classi COCO).

Due motori di inferenza, scelti dall'estensione del modello:
  *.pt   -> ultralytics/PyTorch (PC, usa la GPU CUDA se presente)
  *.onnx -> solo OpenCV DNN, senza PyTorch (Raspberry Pi, QEMU, Yocto)

Uso:
    python main.py                          # telecamera 0, yolo11n.pt
    python main.py --model yolo11n.onnx     # solo OpenCV (come sul dispositivo)
    python main.py --camera 2               # altra telecamera
    python main.py --camera video.mp4       # file video, URL o pipeline GStreamer

Tasti: q / ESC = esci, s = salva screenshot.
"""
import argparse
import os
import threading
import time
from collections import Counter

os.environ.setdefault("QT_LOGGING_RULES", "*.warning=false")  # silenzia avvisi Qt sui font

import cv2
import numpy as np

# Nomi delle classi COCO in italiano
NOMI_IT = {
    "person": "persona", "bicycle": "bicicletta", "car": "auto", "motorcycle": "moto",
    "airplane": "aereo", "bus": "autobus", "train": "treno", "truck": "camion", "boat": "barca",
    "traffic light": "semaforo", "fire hydrant": "idrante", "stop sign": "stop",
    "parking meter": "parchimetro", "bench": "panchina", "bird": "uccello", "cat": "gatto",
    "dog": "cane", "horse": "cavallo", "sheep": "pecora", "cow": "mucca", "elephant": "elefante",
    "bear": "orso", "zebra": "zebra", "giraffe": "giraffa", "backpack": "zaino",
    "umbrella": "ombrello", "handbag": "borsa", "tie": "cravatta", "suitcase": "valigia",
    "frisbee": "frisbee", "skis": "sci", "snowboard": "snowboard", "sports ball": "palla",
    "kite": "aquilone", "baseball bat": "mazza da baseball", "baseball glove": "guantone",
    "skateboard": "skateboard", "surfboard": "tavola da surf", "tennis racket": "racchetta",
    "bottle": "bottiglia", "wine glass": "calice", "cup": "tazza", "fork": "forchetta",
    "knife": "coltello", "spoon": "cucchiaio", "bowl": "ciotola", "banana": "banana",
    "apple": "mela", "sandwich": "panino", "orange": "arancia", "broccoli": "broccoli",
    "carrot": "carota", "hot dog": "hot dog", "pizza": "pizza", "donut": "ciambella",
    "cake": "torta", "chair": "sedia", "couch": "divano", "potted plant": "pianta",
    "bed": "letto", "dining table": "tavolo", "toilet": "WC", "tv": "TV", "laptop": "portatile",
    "mouse": "mouse", "remote": "telecomando", "keyboard": "tastiera", "cell phone": "cellulare",
    "microwave": "microonde", "oven": "forno", "toaster": "tostapane", "sink": "lavandino",
    "refrigerator": "frigorifero", "book": "libro", "clock": "orologio", "vase": "vaso",
    "scissors": "forbici", "teddy bear": "orsacchiotto", "hair drier": "phon",
    "toothbrush": "spazzolino",
}
# L'ordine di NOMI_IT è quello delle classi COCO del modello
CLASSI = list(NOMI_IT)


def colore(cls_id: int) -> tuple[int, int, int]:
    """Colore stabile per ogni classe."""
    return ((cls_id * 67) % 256, (cls_id * 141) % 256, (cls_id * 199) % 256)


class RilevatoreTorch:
    """YOLO tramite ultralytics (richiede PyTorch)."""

    def __init__(self, modello: str, imgsz: int, conf: float):
        import torch
        from ultralytics import YOLO

        self.gpu = torch.cuda.is_available()
        self.model = YOLO(modello)
        self.imgsz, self.conf = imgsz, conf
        self.dispositivo = "GPU (CUDA)" if self.gpu else "CPU"

    def __call__(self, frame):
        r = self.model(frame, conf=self.conf, imgsz=self.imgsz,
                       device=0 if self.gpu else "cpu", verbose=False)[0]
        return [(*map(int, b.xyxy[0]), int(b.cls[0]), float(b.conf[0])) for b in r.boxes]


class RilevatoreOnnx:
    """YOLO esportato in ONNX, eseguito con OpenCV DNN (nessuna dipendenza da PyTorch)."""

    def __init__(self, modello: str, imgsz: int, conf: float, nms: float = 0.45):
        self.net = cv2.dnn.readNet(modello)
        self.imgsz, self.conf, self.nms = imgsz, conf, nms
        self.dispositivo = f"CPU (OpenCV DNN, {cv2.getNumThreads()} thread)"

    def __call__(self, frame):
        h, w = frame.shape[:2]
        s = self.imgsz
        # letterbox: ridimensiona mantenendo le proporzioni e riempie di grigio
        scala = min(s / w, s / h)
        nw, nh = round(w * scala), round(h * scala)
        dx, dy = (s - nw) // 2, (s - nh) // 2
        img = np.full((s, s, 3), 114, np.uint8)
        img[dy:dy + nh, dx:dx + nw] = cv2.resize(frame, (nw, nh), interpolation=cv2.INTER_LINEAR)

        blob = cv2.dnn.blobFromImage(img, 1 / 255.0, (s, s), swapRB=True)
        self.net.setInput(blob)
        out = self.net.forward()[0].T  # (N, 4 + classi): cx, cy, w, h, punteggi

        punteggi = out[:, 4:]
        cls = punteggi.argmax(1)
        conf = punteggi[np.arange(len(cls)), cls]
        keep = conf >= self.conf
        out, cls, conf = out[keep], cls[keep], conf[keep]
        if not len(out):
            return []

        cx, cy, bw, bh = out[:, 0], out[:, 1], out[:, 2], out[:, 3]
        x1 = (cx - bw / 2 - dx) / scala
        y1 = (cy - bh / 2 - dy) / scala
        caselle = np.stack([x1, y1, bw / scala, bh / scala], 1)
        idx = cv2.dnn.NMSBoxesBatched(caselle.tolist(), conf.tolist(), cls.tolist(), self.conf, self.nms)
        risultati = []
        for i in np.array(idx).flatten():
            x, y, bw_, bh_ = caselle[i]
            x1_, y1_ = max(0, int(x)), max(0, int(y))
            x2_, y2_ = min(w - 1, int(x + bw_)), min(h - 1, int(y + bh_))
            risultati.append((x1_, y1_, x2_, y2_, int(cls[i]), float(conf[i])))
        return risultati


class RilevamentoInBackground:
    """Esegue il rilevatore in un thread separato, così il video resta fluido.

    Il ciclo principale consegna l'ultimo frame con invia() e disegna gli ultimi
    risultati disponibili. Se il modello è più lento della telecamera, i frame
    arrivati nel frattempo vengono scartati: si analizza sempre il più recente.
    (OpenCV DNN e PyTorch rilasciano il GIL durante l'inferenza.)
    """

    def __init__(self, rileva):
        self._rileva = rileva
        self._cond = threading.Condition()
        self._frame = None
        self._fine = False
        self.risultati: list = []
        self.fps = 0.0  # rilevamenti al secondo
        self.errore: BaseException | None = None
        self._thread = threading.Thread(target=self._ciclo, name="rilevamento", daemon=True)
        self._thread.start()

    def invia(self, frame) -> None:
        with self._cond:
            self._frame = frame
            self._cond.notify()

    def ferma(self) -> None:
        with self._cond:
            self._fine = True
            self._cond.notify()
        self._thread.join(timeout=5)

    def _ciclo(self) -> None:
        while True:
            with self._cond:
                while self._frame is None and not self._fine:
                    self._cond.wait()
                if self._fine:
                    return
                frame, self._frame = self._frame, None
            t = time.time()
            try:
                risultati = self._rileva(frame)
            except BaseException as e:  # riportato al ciclo principale
                self.errore = e
                return
            durata = max(time.time() - t, 1e-6)
            self.risultati = risultati  # assegnazione atomica: niente lock per leggerla
            self.fps = 1 / durata if not self.fps else 0.8 * self.fps + 0.2 / durata


def apri_sorgente(sorgente: str, larghezza: int, altezza: int, fps: int) -> cv2.VideoCapture:
    if sorgente.isdigit():  # telecamera V4L2
        cap = cv2.VideoCapture(int(sorgente), cv2.CAP_V4L2)
        if cap.isOpened():
            # MJPG permette alle webcam FPS e risoluzioni più alte rispetto a YUYV
            cap.set(cv2.CAP_PROP_FOURCC, cv2.VideoWriter_fourcc(*"MJPG"))
            cap.set(cv2.CAP_PROP_FRAME_WIDTH, larghezza)
            cap.set(cv2.CAP_PROP_FRAME_HEIGHT, altezza)
            cap.set(cv2.CAP_PROP_FPS, fps)
            cap.set(cv2.CAP_PROP_BUFFERSIZE, 1)  # meno ritardo
    elif "!" in sorgente:  # pipeline GStreamer
        cap = cv2.VideoCapture(sorgente, cv2.CAP_GSTREAMER)
    else:  # file video o URL
        cap = cv2.VideoCapture(sorgente)
    if not cap.isOpened():
        raise SystemExit(f"Impossibile aprire la sorgente {sorgente!r}. Prova --camera 1, 2, ...")
    return cap


def main() -> None:
    p = argparse.ArgumentParser(description="Riconoscimento oggetti dalla telecamera")
    p.add_argument("--camera", default=os.environ.get("CAMERA", "0"),
                   help="indice della telecamera, file video, URL o pipeline GStreamer (default 0)")
    p.add_argument("--model", default=os.environ.get("MODEL", "yolo11n.pt"),
                   help="modello YOLO: .pt (ultralytics) o .onnx (OpenCV DNN)")
    p.add_argument("--conf", type=float, default=0.5, help="confidenza minima (0-1)")
    p.add_argument("--imgsz", type=int, default=None,
                   help="dimensione input del modello (default 640 per .pt, 320 per .onnx)")
    p.add_argument("--fps", type=int, default=60, help="FPS richiesti alla telecamera")
    p.add_argument("--width", type=int, default=1280, help="larghezza richiesta alla telecamera")
    p.add_argument("--height", type=int, default=720, help="altezza richiesta alla telecamera")
    p.add_argument("--fullscreen", action="store_true", help="finestra a schermo intero")
    args = p.parse_args()

    onnx = args.model.endswith(".onnx")
    imgsz = args.imgsz or (320 if onnx else 640)
    rileva = (RilevatoreOnnx if onnx else RilevatoreTorch)(args.model, imgsz, args.conf)

    cap = apri_sorgente(args.camera, args.width, args.height, args.fps)
    print(f"Sorgente: {int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))}x{int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))}"
          f" @ {cap.get(cv2.CAP_PROP_FPS):.0f} FPS | modello: {args.model} ({imgsz}px)"
          f" | dispositivo: {rileva.dispositivo}")

    finestra = "Riconoscimento oggetti (q per uscire)"
    cv2.namedWindow(finestra, cv2.WINDOW_NORMAL)
    if args.fullscreen:
        cv2.setWindowProperty(finestra, cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)
    t_prec = time.time()
    fps = 0.0
    sfondo = RilevamentoInBackground(rileva)

    while True:
        ok, frame = cap.read()
        if not ok:
            print("Frame non disponibile, esco.")
            break
        if sfondo.errore:
            raise SystemExit(f"Errore nel rilevamento: {sfondo.errore!r}")
        # copia: il thread analizza il frame mentre qui ci disegniamo sopra
        sfondo.invia(frame.copy())

        conteggio = Counter()
        for x1, y1, x2, y2, cls_id, conf in sfondo.risultati:
            inglese = CLASSI[cls_id] if cls_id < len(CLASSI) else str(cls_id)
            nome = NOMI_IT.get(inglese, inglese)
            conteggio[nome] += 1
            c = colore(cls_id)
            etichetta = f"{nome} {conf:.0%}"
            cv2.rectangle(frame, (x1, y1), (x2, y2), c, 2)
            (tw, th), _ = cv2.getTextSize(etichetta, cv2.FONT_HERSHEY_SIMPLEX, 0.6, 2)
            cv2.rectangle(frame, (x1, y1 - th - 8), (x1 + tw + 6, y1), c, -1)
            cv2.putText(frame, etichetta, (x1 + 3, y1 - 5), cv2.FONT_HERSHEY_SIMPLEX,
                        0.6, (255, 255, 255), 2)

        # FPS e riepilogo oggetti
        ora = time.time()
        fps = 0.9 * fps + 0.1 * (1 / max(ora - t_prec, 1e-6))
        t_prec = ora
        righe = [f"Video: {fps:.1f} FPS | rilevamento: {sfondo.fps:.1f} al s"] + [f"{n}: {k}" for n, k in conteggio.most_common()]
        for i, r in enumerate(righe):
            cv2.putText(frame, r, (10, 25 + i * 24), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 0, 0), 4)
            cv2.putText(frame, r, (10, 25 + i * 24), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 0), 2)

        cv2.imshow(finestra, frame)
        tasto = cv2.waitKey(1) & 0xFF
        if tasto in (ord("q"), 27):
            break
        if tasto == ord("s"):
            nome_file = f"screenshot_{time.strftime('%Y%m%d_%H%M%S')}.jpg"
            cv2.imwrite(nome_file, frame)
            print("Salvato", nome_file)
        # Finestra chiusa con la X: AUTOSIZE vale -1 se la finestra non esiste più.
        # (WND_PROP_VISIBLE non va bene: con GTK, usato su Yocto, vale sempre -1;
        # con Qt, usato sul PC, su una finestra chiusa solleva un errore.)
        try:
            if cv2.getWindowProperty(finestra, cv2.WND_PROP_AUTOSIZE) < 0:
                break
        except cv2.error:
            break

    sfondo.ferma()
    cap.release()
    cv2.destroyAllWindows()


if __name__ == "__main__":
    main()
