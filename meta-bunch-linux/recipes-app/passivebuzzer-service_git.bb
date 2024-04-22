LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://git@github.com/waelkarman/passivebuzzer-service.git;protocol=ssh;branch=master"

PV = "1.0+git${SRCPV}"
SRCREV = "17d494af60537c66a521fe66f50c547e8c2f4ecd"

S = "${WORKDIR}/git"

RDEPENDS:${PN} += "python3-pyzmq python3"

do_install:append() {
	install -Dm644 ${S}/passiveBuzzer.py ${D}/${bindir}/passiveBuzzer.py
}