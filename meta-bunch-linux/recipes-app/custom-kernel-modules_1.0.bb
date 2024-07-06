LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://git@github.com/waelkarman/kernel-modules.git;protocol=ssh;branch=master"

PV = "1.0+git${SRCPV}"
SRCREV = "365d3d4cb02ac6d2ed4d53f8212729e074ee03d1"

S = "${WORKDIR}/git"

inherit module
