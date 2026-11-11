LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://github.com/waelkarman/burger-shop.git;protocol=https;branch=main"

# Modify these as desired
PV = "1.0+git"
SRCREV = "8170077844660b8c8315e0fcea8a3ca80b7c9f62"

DEPENDS = "qtbase qtdeclarative qtdeclarative-native weston-init qtwayland"

inherit qt6-cmake

