# Hotspot on wlan0 (BUNCH_WLAN_MODE = "ap"). The passphrase comes from
# secrets/hotspot.psk and is never committed.
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

inherit systemd bunch-secrets

BUNCH_REQUIRED_SECRETS = "hotspot.psk"

SRC_URI += " \
    file://hostapd.conf \
    file://hostapd.service \
    file://setup-hotspot.sh \
    file://hotspot.psk \
"

SYSTEMD_SERVICE:${PN} = "hostapd.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install:append() {
    psk=$(head -n 1 ${UNPACKDIR}/hotspot.psk)
    if [ ${#psk} -lt 8 ] || [ ${#psk} -gt 63 ]; then
        bbfatal "hotspot.psk: the WPA2 passphrase must be 8-63 characters"
    fi
    install -Dm 0600 ${UNPACKDIR}/hostapd.conf ${D}${sysconfdir}/hostapd.conf
    printf 'wpa_passphrase=%s\n' "$psk" >> ${D}${sysconfdir}/hostapd.conf

    install -Dm 0644 ${UNPACKDIR}/hostapd.service ${D}${systemd_system_unitdir}/hostapd.service
    install -Dm 0755 ${UNPACKDIR}/setup-hotspot.sh ${D}${sbindir}/bunch-setup-hotspot
}

RDEPENDS:${PN} += "iproute2 iptables dnsmasq"
