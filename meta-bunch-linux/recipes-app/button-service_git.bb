LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://github.com/waelkarman/button-service.git;protocol=https;branch=master"

PV = "1.0+git"
SRCREV = "2d1faf617d6234cb3db2fa470e48c7544664ee14"

inherit cmake

DEPENDS = "sysfsgpio zmqpp cppzmq zeromq"