SUMMARY = "LLM inference in C/C++ (llama.cpp): llama-server, llama-cli and tools"
DESCRIPTION = "llama.cpp runs GGUF language models on the CPU (ggml, NEON on the \
Cortex-A72). llama-cpp ships the libraries and the command line tools \
(llama-cli, llama-bench, ...); llama-cpp-server the systemd service that \
serves the default model with an OpenAI-compatible API on localhost."
HOMEPAGE = "https://github.com/ggml-org/llama.cpp"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=223b26b3c1143120c87e2b13111d3e99"

# Tag v1.0.0 (build b12359)
SRC_URI = " \
    git://github.com/ggml-org/llama.cpp.git;protocol=https;branch=master \
    file://llama-server.service \
    file://llama-server.default \
"
SRCREV = "b1b770d90d94cad9e9ea5b993bdbc383a522fb28"
LLAMA_BUILD_NUMBER = "12359"
LLAMA_BUILD_COMMIT = "b1b770d"

# Shallow fetch of SRCREV only (~40 MB, git fetch --depth 1). A full clone is
# --mirror, which on GitHub includes every refs/pull/*: several GB for
# llama.cpp. (GitHub archive tarballs are rejected by QA: src-uri-bad.)
BB_GIT_SHALLOW = "1"
BB_GIT_SHALLOW_DEPTH = "1"

inherit cmake systemd

# - GGML_NATIVE=OFF: cross build, the CPU flags come from the tune (-mcpu=cortex-a72)
# - no embedded Web UI: it is downloaded from Hugging Face or built with npm at
#   build time (no network in do_compile); the GUI is llm-chat (GTK3)
# - no OpenSSL: the server listens on localhost only and models are not
#   downloaded at runtime (-hf/-mu)
# - build number/commit passed explicitly: a depth-1 clone cannot count commits
EXTRA_OECMAKE += " \
    -DGGML_NATIVE=OFF \
    -DGGML_CCACHE=OFF \
    -DLLAMA_BUILD_TESTS=OFF \
    -DLLAMA_BUILD_EXAMPLES=OFF \
    -DLLAMA_BUILD_APP=OFF \
    -DLLAMA_BUILD_TOOLS=ON \
    -DLLAMA_BUILD_SERVER=ON \
    -DLLAMA_BUILD_UI=OFF \
    -DLLAMA_USE_PREBUILT_UI=OFF \
    -DLLAMA_OPENSSL=OFF \
    -DLLAMA_BUILD_NUMBER=${LLAMA_BUILD_NUMBER} \
    -DLLAMA_BUILD_COMMIT=${LLAMA_BUILD_COMMIT} \
"

do_install:append() {
    install -Dm 0644 ${UNPACKDIR}/llama-server.service ${D}${systemd_system_unitdir}/llama-server.service
    install -Dm 0644 ${UNPACKDIR}/llama-server.default ${D}${sysconfdir}/default/llama-server
}

PACKAGE_BEFORE_PN = "${PN}-server"

# Each tool links a private, unversioned lib<tool>-impl.so (no SONAME
# version): it belongs to the runtime package, not to -dev. Only the real
# development symlinks of the versioned libraries go to -dev.
FILES_SOLIBSDEV = ""
FILES:${PN}-dev += " \
    ${libdir}/libggml.so ${libdir}/libggml-base.so ${libdir}/libggml-cpu.so \
    ${libdir}/libllama.so ${libdir}/libllama-common.so ${libdir}/libmtmd.so \
"
FILES:${PN} += "${libdir}/libllama-*-impl.so"

FILES:${PN}-server = "${systemd_system_unitdir}/llama-server.service ${sysconfdir}/default/llama-server"
CONFFILES:${PN}-server = "${sysconfdir}/default/llama-server"
RDEPENDS:${PN}-server = "${PN}"

SYSTEMD_PACKAGES = "${PN}-server"
SYSTEMD_SERVICE:${PN}-server = "llama-server.service"
SYSTEMD_AUTO_ENABLE = "enable"
