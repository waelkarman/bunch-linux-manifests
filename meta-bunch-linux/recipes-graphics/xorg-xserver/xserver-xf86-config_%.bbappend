FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:bunch-raspberrypi4-64 = " \
    file://xorg.conf.d/98-pitft.conf \
    file://xorg.conf.d/99-calibration.conf \
"
do_install:append:bunch-raspberrypi4-64 () {
    PITFT="${@bb.utils.contains("MACHINE_FEATURES", "pitft", "1", "0", d)}"
    if [ "${PITFT}" = "1" ]; then
        install -d ${D}/${sysconfdir}/X11/xorg.conf.d/
        install -m 0644 ${WORKDIR}/xorg.conf.d/98-pitft.conf ${D}/${sysconfdir}/X11/xorg.conf.d/
        install -m 0644 ${WORKDIR}/xorg.conf.d/99-calibration.conf ${D}/${sysconfdir}/X11/xorg.conf.d/
    fi
}

FILES:${PN}:append:bunch-raspberrypi4-64 = " ${sysconfdir}/X11/xorg.conf.d/*"
