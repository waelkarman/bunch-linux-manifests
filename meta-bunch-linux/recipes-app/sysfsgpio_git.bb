LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://github.com/waelkarman/Raspberry-Pi-Sysfs-GPIO-C-Library.git;protocol=https;branch=master"

PV = "1.0+git"
SRCREV = "0f6bf8f250730072ae9ecd2e97dcc41053e8699b"

inherit cmake

# The library is unversioned (no SONAME version): ship the .so in the
# runtime package instead of -dev.
FILES_SOLIBSDEV = ""
FILES:${PN} += "${libdir}/libsysfsgpio.so"
INSANE_SKIP:${PN} += "dev-so"

do_install:append() {
    install -d ${D}${includedir}
    install -m 0644 ${S}/*.h ${D}${includedir}/
}