LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://github.com/waelkarman/passivebuzzer-service.git;protocol=https;branch=master"

PV = "1.0+git"
SRCREV = "17d494af60537c66a521fe66f50c547e8c2f4ecd"

RDEPENDS:${PN} += "python3-pyzmq python3"

do_install:append() {
	install -Dm 0755 ${S}/passiveBuzzer.py ${D}${bindir}/passiveBuzzer.py
}