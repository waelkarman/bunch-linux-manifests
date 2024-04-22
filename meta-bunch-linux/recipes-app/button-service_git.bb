LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://git@github.com/waelkarman/button-service.git;protocol=ssh;branch=master"

PV = "1.0+git${SRCPV}"
SRCREV = "2d1faf617d6234cb3db2fa470e48c7544664ee14"

S = "${WORKDIR}/git"

inherit cmake

DEPENDS = "sysfsgpio zmqpp cppzmq zeromq"