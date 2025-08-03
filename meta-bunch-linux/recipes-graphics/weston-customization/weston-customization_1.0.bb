SUMMARY = "configure weston env"
LICENSE = "CLOSED"

DEPENDS += "weston weston-init"
SRC_URI += "file://gear.png \
            file://terminal1.png \
            file://folder.png \
            file://background.jpg \
            file://burger.png \
            file://player.png \
            "

FILES:${PN} = "/usr \
  /usr/share \
  /usr/share/icons \
  /usr/share/icons/weston \
  /usr/share/backgrounds \
  "

do_install:append() {
    install -Dm 644 ${WORKDIR}/gear.png ${D}/usr/share/weston/gear.png
    install -Dm 644 ${WORKDIR}/terminal1.png ${D}/usr/share/weston/terminal1.png
    install -Dm 644 ${WORKDIR}/folder.png ${D}/usr/share/weston/folder.png
    install -Dm 644 ${WORKDIR}/background.jpg ${D}/usr/share/backgrounds/background.jpg
    install -Dm 644 ${WORKDIR}/burger.png ${D}/usr/share/weston/burger.png
    install -Dm 644 ${WORKDIR}/player.png ${D}/usr/share/weston/player.png
}
