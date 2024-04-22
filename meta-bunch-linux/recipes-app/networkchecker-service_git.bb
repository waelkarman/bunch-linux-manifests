LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://git@github.com/waelkarman/networkchecker-service.git;protocol=ssh;branch=master"

# Modify these as desired
PV = "1.0+git${SRCPV}"
SRCREV = "04032983d53c4e76760b44c10b49b9539555a499"

S = "${WORKDIR}/git"

RDEPENDS:${PN} += "python3-pyzmq python3"

do_install:append() {
	install -Dm644 ${S}/networkchecker.py ${D}/${bindir}/networkchecker.py
}