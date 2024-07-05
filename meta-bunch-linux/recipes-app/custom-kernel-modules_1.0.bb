LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://git@github.com/waelkarman/custom-kernel-modules.git;protocol=ssh;branch=master"

PV = "1.0+git${SRCPV}"
SRCREV = "4d8969f4c282a5dc9e50a75f6ef3ae0f10ea4456"

S = "${WORKDIR}/git"

inherit module
