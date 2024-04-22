LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://git@github.com/waelkarman/hello-module.git;protocol=ssh;branch=master"

PV = "1.0+git${SRCPV}"
SRCREV = "8c012f0b82b22b0f7d9bfcf7e67f2640ea9f9f13"

S = "${WORKDIR}/git"

inherit module