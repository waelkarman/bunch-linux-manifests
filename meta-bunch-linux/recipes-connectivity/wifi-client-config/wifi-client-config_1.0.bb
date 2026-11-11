SUMMARY = "wlan0 as Wi-Fi client: wpa_supplicant@wlan0 + DHCP via systemd-networkd"
DESCRIPTION = "Used when BUNCH_WLAN_MODE = \"client\". The network credentials \
come from secrets/wpa_supplicant-wlan0.conf and are never committed."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit allarch bunch-secrets

BUNCH_REQUIRED_SECRETS = "wpa_supplicant-wlan0.conf"

SRC_URI = " \
    file://20-wlan0.network \
    file://wpa_supplicant-wlan0.conf \
"

S = "${UNPACKDIR}"

do_install() {
    install -Dm 0644 ${UNPACKDIR}/20-wlan0.network ${D}${sysconfdir}/systemd/network/20-wlan0.network
    install -Dm 0600 ${UNPACKDIR}/wpa_supplicant-wlan0.conf ${D}${sysconfdir}/wpa_supplicant/wpa_supplicant-wlan0.conf

    # Enable the upstream template unit for wlan0 (shipped by wpa-supplicant).
    install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants
    ln -sf ${systemd_system_unitdir}/wpa_supplicant@.service \
        ${D}${sysconfdir}/systemd/system/multi-user.target.wants/wpa_supplicant@wlan0.service
}

FILES:${PN} = "${sysconfdir}"
RDEPENDS:${PN} = "wpa-supplicant"
