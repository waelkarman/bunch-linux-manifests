# Recipe created by recipetool
# This is the basis of a recipe and may need further editing in order to be fully functional.
# (Feel free to remove these comments when editing.)

SUMMARY = "0mq 'highlevel' C++ bindings"
# WARNING: the following LICENSE and LIC_FILES_CHKSUM values are best guesses - it is
# your responsibility to verify that the values are complete and correct.
LICENSE = "MPL-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=815ca599c9df247a0c7f619bab123dad"

SRC_URI = "git://github.com/zeromq/zmqpp.git;protocol=https;branch=develop"

# Modify these as desired
PV = "1.0+git"
SRCREV = "ba4230d5d03d29ced9ca788e3bd1095477db08ae"

# NOTE: the following library dependencies are unknown, ignoring: libzmq
#       (this is based on recipes that have previously been built and packaged)
DEPENDS = "boost zeromq"

# NOTE: spec file indicates the license may be "LGPLv3"
inherit cmake

# The library is unversioned: ship the .so in the runtime package.
FILES_SOLIBSDEV = ""
FILES:${PN} += "${libdir}/libzmqpp.so"
INSANE_SKIP:${PN} += "dev-so"