LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://git@github.com/waelkarman/open-pipe-media-player.git;protocol=https;branch=main"

# Modify these as desired
PV = "1.0+git${SRCPV}"
SRCREV = "366e32d535c6e73fb7c51dfd098b455687c89684"

S = "${WORKDIR}/git"

inherit cmake pkgconfig
DEPENDS = " gtk+3 glibc gstreamer1.0 weston-init qtwayland gstreamer1.0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad"

#do_install:append() {
#	install -Dm644 ${S}/open-pipe-media-player ${D}/${bindir}/open-pipe-media-player
#}
