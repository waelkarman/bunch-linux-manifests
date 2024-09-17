LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://github.com/Rafostar/clapper.git;protocol=https"

# Modify these as desired
PV = "1.0+git${SRCPV}"
SRCREV = "0.4.0"

S = "${WORKDIR}/git"

inherit meson pkgconfig
DEPENDS = " gtk4 gjs glibc gstreamer1.0 weston-init qtwayland gstreamer1.0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad"

