FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://dnsmasq.conf"

# Started by hostapd.service (hotspot mode) only, never on its own:
# it serves DHCP on wlan0.
SYSTEMD_AUTO_ENABLE:${PN} = "disable"

do_install:append() {
    install -m 0644 ${UNPACKDIR}/dnsmasq.conf ${D}${sysconfdir}/dnsmasq.conf
}
