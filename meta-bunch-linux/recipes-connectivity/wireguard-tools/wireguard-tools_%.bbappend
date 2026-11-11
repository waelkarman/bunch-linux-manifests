# WireGuard uplink of the hotspot. The configuration contains private keys,
# so it is taken from secrets/wg0.conf and is optional: without it the tools
# are installed but wg-quick@wg0 is not enabled.
inherit systemd bunch-secrets

BUNCH_HAS_WG0 = "${@'1' if bunch_secret_exists(d, 'wg0.conf') else '0'}"

SRC_URI += "${@'file://wg0.conf' if d.getVar('BUNCH_HAS_WG0') == '1' else ''}"

do_install:append() {
    if [ "${BUNCH_HAS_WG0}" = "1" ]; then
        install -Dm 0600 ${UNPACKDIR}/wg0.conf ${D}${sysconfdir}/wireguard/wg0.conf
    fi
}

SYSTEMD_SERVICE:${PN} = "wg-quick@wg0.service"
SYSTEMD_AUTO_ENABLE:${PN} = "${@'enable' if d.getVar('BUNCH_HAS_WG0') == '1' else 'disable'}"

FILES:${PN} += "${sysconfdir}/wireguard"
