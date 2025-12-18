# recipes-kernel/linux/linux-raspberrypi_6.12.bbappend

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRCREV_machine = "abc097cdb0cf6917e80692860b202a79b2e664b5"
PV = "6.12.61+git${SRCPV}"

SRC_URI = " \
    git://github.com/waelkarman/linux.git;name=machine;branch=${LINUX_RPI_BRANCH};protocol=https \
    git://git.yoctoproject.org/yocto-kernel-cache;type=kmeta;name=meta;branch=${LINUX_RPI_KMETA_BRANCH};destsuffix=${KMETA} \
    file://powersave.cfg \
    file://android-drivers.cfg \
    file://bunch-linux.cfg \
"