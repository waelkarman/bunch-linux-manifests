SUMMARY = "configure weston env"
LICENSE = "CLOSED"

SRC_URI += "file://environment-weston"

do_install:append() {
    install -Dm755 ${WORKDIR}/environment-weston ${D}/${sysconfdir}/environment
}
