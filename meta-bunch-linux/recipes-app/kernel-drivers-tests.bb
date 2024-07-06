LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://git@github.com/waelkarman/kernel-drivers-tests.git;protocol=ssh;branch=main"

PV = "1.0+git${SRCPV}"
SRCREV = "377fe30f9f77f179c62009f43f2d7324433d5949"

S = "${WORKDIR}/git"

inherit cmake
