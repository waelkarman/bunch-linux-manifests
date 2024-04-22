
LICENSE = "CLOSED"

SRC_URI += "file://update.service \
            file://update.timer \
            file://bunch-update.sh \
            "

inherit systemd

do_install:append() {
    install -Dm755 ${WORKDIR}/bunch-update.sh ${D}/${bindir}/bunch-update.sh
    install -Dm 644 ${WORKDIR}/update.service ${D}${systemd_system_unitdir}/update.service
    install -Dm 644 ${WORKDIR}/update.timer ${D}${systemd_system_unitdir}/update.timer
}
RDEPENDS:${PN} += " curl"
FILES:${PN} += "/lib/systemd/system/update.service \
                /lib/systemd/system/update.timer \
"

SYSTEMD_SERVICE:${PN} = "update.timer update.service"
SYSTEMD_AUTO_ENABLE = "enable"
