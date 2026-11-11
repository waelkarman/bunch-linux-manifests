SUMMARY = "Systemd service for sensors and info collector"
LICENSE = "CLOSED"

RDEPENDS:${PN} = " button-service networkchecker-service passivebuzzer-service "

inherit systemd

S = "${UNPACKDIR}"

SRC_URI = "\
    file://buttonreaderservices.service \
    file://networkcheckerservice.service \
    file://passivebuzzerservice.service \
"

do_install() {
    install -Dm 644 ${UNPACKDIR}/buttonreaderservices.service ${D}${systemd_system_unitdir}/buttonreaderservices.service
    install -Dm 644 ${UNPACKDIR}/networkcheckerservice.service ${D}${systemd_system_unitdir}/networkcheckerservice.service
    install -Dm 644 ${UNPACKDIR}/passivebuzzerservice.service ${D}${systemd_system_unitdir}/passivebuzzerservice.service
}

SYSTEMD_SERVICE:${PN} = "buttonreaderservices.service \
                        networkcheckerservice.service \
                        passivebuzzerservice.service \
                        "
SYSTEMD_AUTO_ENABLE = "enable"