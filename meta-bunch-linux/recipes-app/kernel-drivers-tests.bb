LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://git@github.com/waelkarman/kernel-drivers-tests.git;protocol=ssh;branch=main"

PV = "1.0+git${SRCPV}"
SRCREV = "e6bf4d0b8955abf79dd9c7c672cf3dbf8cd0957b"

S = "${WORKDIR}/git"

inherit cmake
