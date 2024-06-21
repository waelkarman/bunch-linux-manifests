FILESEXTRAPATHS:prepend := "${THISDIR}/connman:"

SRC_URI:append = " file://connman.conf"

do_install:append() {
    install -d ${D}${sysconfdir}/connman
    install -m 0644 ${WORKDIR}/connman.conf ${D}${sysconfdir}/connman/main.conf
}
