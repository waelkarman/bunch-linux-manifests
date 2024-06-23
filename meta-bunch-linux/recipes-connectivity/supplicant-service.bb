SUMMARY = "Systemd service for sensors and info collector"
LICENSE = "CLOSED"

inherit systemd

SRC_URI = "\
    file://wpa_supplicant@wlan0.service \
"

do_install() {
    install -Dm 644 ${WORKDIR}/wpa_supplicant@wlan0.service ${D}${systemd_system_unitdir}/wpa_supplicant@wlan0.service
}

SYSTEMD_SERVICE:${PN} = "wpa_supplicant@wlan0.service \
                        "
SYSTEMD_AUTO_ENABLE = "enable"