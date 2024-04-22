FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI:append := " file://system.conf"

RDEPENDS:${PN} += "mmc-utils"
