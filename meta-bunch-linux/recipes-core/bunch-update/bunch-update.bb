SUMMARY = "Bunch Linux automatic RAUC update service"
LICENSE = "CLOSED"

SRC_URI = " \
    file://update.service \
    file://update.timer \
    file://bunch-update.sh \
"

inherit systemd

do_install() {
    install -Dm 0755 ${UNPACKDIR}/bunch-update.sh ${D}${bindir}/bunch-update.sh
    install -Dm 0644 ${UNPACKDIR}/update.service ${D}${systemd_system_unitdir}/update.service
    install -Dm 0644 ${UNPACKDIR}/update.timer ${D}${systemd_system_unitdir}/update.timer
}

RDEPENDS:${PN} += "curl jq rauc"

# The timer starts update.service; the service itself is not enabled.
SYSTEMD_SERVICE:${PN} = "update.timer"
SYSTEMD_AUTO_ENABLE = "enable"
