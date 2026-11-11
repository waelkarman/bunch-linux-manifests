SUMMARY = "configure weston env"
LICENSE = "CLOSED"

SRC_URI += "file://gear.png \
            file://terminal1.png \
            file://folder.png \
            file://background.jpg \
            file://burger.png \
            file://player.png \
            "

S = "${UNPACKDIR}"

FILES:${PN} = "${datadir}/weston ${datadir}/backgrounds"

do_install() {
    install -Dm 644 ${UNPACKDIR}/gear.png ${D}${datadir}/weston/gear.png
    install -Dm 644 ${UNPACKDIR}/terminal1.png ${D}${datadir}/weston/terminal1.png
    install -Dm 644 ${UNPACKDIR}/folder.png ${D}${datadir}/weston/folder.png
    install -Dm 644 ${UNPACKDIR}/background.jpg ${D}${datadir}/backgrounds/background.jpg
    install -Dm 644 ${UNPACKDIR}/burger.png ${D}${datadir}/weston/burger.png
    install -Dm 644 ${UNPACKDIR}/player.png ${D}${datadir}/weston/player.png
}
