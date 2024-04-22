LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://github.com/waelkarman/sensors-app.git;protocol=https;branch=master"

# Modify these as desired
PV = "1.0+git${SRCPV}"
SRCREV = "427825eb2d69465e831556ab0ab1d79955e8414e"

S = "${WORKDIR}/git"

DEPENDS = "qtbase qtdeclarative qtdeclarative-native weston-init qtwayland zmqpp cppzmq zeromq"

inherit qt6-cmake
