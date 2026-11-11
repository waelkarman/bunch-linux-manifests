LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://github.com/waelkarman/networkchecker-service.git;protocol=https;branch=master"

# Modify these as desired
PV = "1.0+git"
SRCREV = "04032983d53c4e76760b44c10b49b9539555a499"

RDEPENDS:${PN} += "python3-pyzmq python3"

do_install:append() {
	install -Dm 0755 ${S}/networkchecker.py ${D}${bindir}/networkchecker.py
}