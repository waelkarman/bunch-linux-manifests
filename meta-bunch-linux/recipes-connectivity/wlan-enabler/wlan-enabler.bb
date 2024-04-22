
LICENSE = "CLOSED"

SRC_URI += "file://wlan-enabler.service \
            file://wlan-enabler.sh \
            "

inherit systemd

do_install:append() {
    install -Dm755 ${WORKDIR}/wlan-enabler.sh ${D}/${bindir}/wlan-enabler.sh
    install -Dm 644 ${WORKDIR}/wlan-enabler.service ${D}${systemd_system_unitdir}/wlan-enabler.service
}
RDEPENDS:${PN} += " curl"
FILES:${PN} += "/lib/systemd/system/wlan-enabler.service \
"

SYSTEMD_SERVICE:${PN} = "wlan-enabler.service"
SYSTEMD_AUTO_ENABLE = "enable"
