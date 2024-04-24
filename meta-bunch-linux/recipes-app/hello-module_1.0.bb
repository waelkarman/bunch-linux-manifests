LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://git@github.com/waelkarman/hello-module.git;protocol=ssh;branch=master"

PV = "1.0+git${SRCPV}"
SRCREV = "5f2736cb67331161b25795f78cd56aaf08726e8d"

S = "${WORKDIR}/git"

inherit module
