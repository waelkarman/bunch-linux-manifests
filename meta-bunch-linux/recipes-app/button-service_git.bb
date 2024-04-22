LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://git@github.com/waelkarman/button-service.git;protocol=ssh;branch=master"

PV = "1.0+git${SRCPV}"
SRCREV = "39b9a6f5483fd461f9684ec6d45243642db4ca8f"

S = "${WORKDIR}/git"

inherit cmake

DEPENDS = "sysfsgpio zmqpp cppzmq zeromq"