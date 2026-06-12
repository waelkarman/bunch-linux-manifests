# recipes-kernel/linux/linux-raspberrypi_6.12.bbappend

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRCREV_machine = "ad7dc82fc5b05210f6873fac32bf574768a74050"
PV = "6.12.61+git${SRCPV}"
LINUX_RPI_BRANCH = "dev"

SRC_URI = " \
    git://github.com/waelkarman/linux.git;name=machine;branch=${LINUX_RPI_BRANCH};protocol=https \
    git://git.yoctoproject.org/yocto-kernel-cache;type=kmeta;name=meta;branch=${LINUX_RPI_KMETA_BRANCH};destsuffix=${KMETA} \
    file://powersave.cfg \
    file://android-drivers.cfg \
    file://bunch-linux.cfg \
"

do_deploy:append() {
    install -m 0644 ${B}/.config ${DEPLOYDIR}/kernel.config
}