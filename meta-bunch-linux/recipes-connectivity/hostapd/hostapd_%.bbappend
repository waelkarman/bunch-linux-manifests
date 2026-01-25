FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://hostapd.conf \
            file://hostapd.service \
            file://setup-hotspot.sh"

# Add this if not inherited elsewhere
inherit systemd

# Declare the service
SYSTEMD_SERVICE:${PN} = "hostapd.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install:append() {
    # Config hostapd
    install -d ${D}${sysconfdir}
    install -m 0644 ${WORKDIR}/hostapd.conf ${D}${sysconfdir}/hostapd.conf

    # Servizio systemd
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/hostapd.service ${D}${systemd_unitdir}/system/

    # Script di setup hotspot
    install -d ${D}/usr/local/bin
    install -m 0755 ${WORKDIR}/setup-hotspot.sh ${D}/usr/local/bin/setup-hotspot.sh
}


FILES:${PN} += "${systemd_unitdir}/system/hostapd.service"