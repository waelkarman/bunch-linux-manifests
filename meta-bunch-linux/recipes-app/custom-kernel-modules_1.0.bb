LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://git@github.com/waelkarman/kernel-modules.git;protocol=ssh;branch=master"

PV = "1.0+git${SRCPV}"
SRCREV = "1d4e2efc71564e7555fb004740784b15917722c2"

S = "${WORKDIR}/git"

inherit module
