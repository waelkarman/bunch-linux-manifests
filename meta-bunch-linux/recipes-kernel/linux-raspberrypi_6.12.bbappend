# recipes-kernel/linux/linux-raspberrypi_6.12.bbappend

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRCREV_machine = "d861ec5b874418372ed349f00bc153b085dfb0d4"
PV = "6.12.61+git${SRCPV}"

SRC_URI = " \
    git://github.com/waelkarman/linux.git;name=machine;branch=${LINUX_RPI_BRANCH};protocol=https \
    git://git.yoctoproject.org/yocto-kernel-cache;type=kmeta;name=meta;branch=${LINUX_RPI_KMETA_BRANCH};destsuffix=${KMETA} \
    file://powersave.cfg \
    file://android-drivers.cfg \
    file://bunch-linux.cfg \
"