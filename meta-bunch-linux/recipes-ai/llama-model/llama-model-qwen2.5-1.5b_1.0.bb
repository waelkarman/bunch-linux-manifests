SUMMARY = "Qwen2.5-1.5B-Instruct (GGUF Q4_0): default language model for llama-server"
DESCRIPTION = "Multilingual 1.5B chat model (Italian included) by the Qwen team, \
quantized to 4 bit (Q4_0, ~1 GB). Q4_0 is repacked at load time for the NEON \
kernels of ggml, the fastest 4-bit format on the Cortex-A72. Installed as \
/usr/share/llama/models/default.gguf, the model served by llama-cpp-server."
HOMEPAGE = "https://huggingface.co/Qwen/Qwen2.5-1.5B-Instruct-GGUF"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

# Pinned to a commit of the Hugging Face repository (1066227232 bytes)
HF_REPO = "Qwen/Qwen2.5-1.5B-Instruct-GGUF"
HF_COMMIT = "91cad51170dc346986eccefdc2dd33a9da36ead9"
MODEL_FILE = "qwen2.5-1.5b-instruct-q4_0.gguf"

SRC_URI = "https://huggingface.co/${HF_REPO}/resolve/${HF_COMMIT}/${MODEL_FILE}"
SRC_URI[sha256sum] = "dcd819ff094852c38faba6873d8ff0c9d51eadb2844539e52042ae5d647bbfdb"

S = "${UNPACKDIR}"

inherit allarch
INHIBIT_DEFAULT_DEPS = "1"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    install -Dm 0644 ${S}/${MODEL_FILE} ${D}${datadir}/llama/models/${MODEL_FILE}
    ln -sf ${MODEL_FILE} ${D}${datadir}/llama/models/default.gguf
}

FILES:${PN} = "${datadir}/llama/models"

# Every model package provides default.gguf: install only one of them
RPROVIDES:${PN} = "llama-model-default"
