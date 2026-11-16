SUMMARY = "Chat with the local language model (llama-server) in a GTK3 window"
DESCRIPTION = "Python3/PyGObject app for Weston: talks to llama-server through its \
OpenAI-compatible API (/v1/chat/completions) and shows the answer while it is \
generated. Everything runs on the device, no network needed."
LICENSE = "CLOSED"

SRC_URI = " \
    file://llm-chat.py \
    file://llm-chat \
"

S = "${UNPACKDIR}"

inherit allarch

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    install -Dm 0755 ${S}/llm-chat ${D}${bindir}/llm-chat
    install -Dm 0644 ${S}/llm-chat.py ${D}${datadir}/llm-chat/llm-chat.py
}

FILES:${PN} = "${bindir}/llm-chat ${datadir}/llm-chat"

# urllib/http: python3-netclient; the Gtk/Gdk/Pango typelibs come with gtk+3
RDEPENDS:${PN} = "python3-core python3-json python3-netclient python3-pygobject gtk+3"
# The server and a model (llama-model-default); --url can point to a remote server
RRECOMMENDS:${PN} = "llama-cpp-server llama-model-default"
