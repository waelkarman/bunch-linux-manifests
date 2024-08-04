LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://git@github.com/waelkarman/gtk4-music-player.git;protocol=https;branch=master"

# Modify these as desired
PV = "1.0+git${SRCPV}"
SRCREV = "8fab11d12fdf8f1a72c405b31b9d10111fa4fa5e"

S = "${WORKDIR}/git"

inherit meson vala pkgconfig
DEPENDS = " desktop-file-utils-native gtk4-native vala-native meson libadwaita gettext gtk4 glibc gstreamer1.0 weston-init qtwayland gstreamer1.0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad"

FILES:${PN} += "\
    /usr/share/metainfo \
    /usr/share/dbus-1 \
    /usr/share/dbus-1/services \
    /usr/share/dbus-1/services/com.github.neithern.g4music.service \
    /usr/share/icons/hicolor/scalable/apps/com.github.neithern.g4music.svg \
    /usr/share/icons/hicolor/symbolic/apps/com.github.neithern.g4music-symbolic.svg \
    /usr/share/glib-2.0/schemas/com.github.neithern.g4music.gschema.xml \
"
