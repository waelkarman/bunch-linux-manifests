LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://git@github.com/waelkarman/hello-module.git;protocol=ssh;branch=master"

PV = "1.0+git${SRCPV}"
SRCREV = "708b576a51f186b76e966d09d24027afa81196a3"

S = "${WORKDIR}/git"

inherit module
