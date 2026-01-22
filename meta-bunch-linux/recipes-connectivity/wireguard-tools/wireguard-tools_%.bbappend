inherit systemd

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://wg0.conf"

do_install:append() {
    install -d ${D}${sysconfdir}/wireguard
    install -m 0600 ${WORKDIR}/wg0.conf ${D}${sysconfdir}/wireguard/wg0.conf
}

SYSTEMD_SERVICE:${PN} = "wg-quick@wg0.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

FILES:${PN} += "${sysconfdir}/wireguard/wg0.conf"