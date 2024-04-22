LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://git@github.com/waelkarman/Raspberry-Pi-Sysfs-GPIO-C-Library.git;protocol=ssh;branch=master"

PV = "1.0+git${SRCPV}"
SRCREV = "0f6bf8f250730072ae9ecd2e97dcc41053e8699b"

S = "${WORKDIR}/git"

inherit cmake

EXTRA_OECMAKE = ""
FILES_SOLIBSDEV = ""
FILES:${PN} = "/usr/lib/libsysfsgpio.so"

do_install:append() {
    install -d ${D}${includedir}/
    cp -r ${S}/*.h ${D}${includedir}/
}