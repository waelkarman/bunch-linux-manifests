# Bunch Linux kernel: fork of raspberrypi/linux rpi-6.12.y with the
# buzzer / PCA9685 drivers and overlays.
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

LINUX_VERSION = "6.12.61"
LINUX_RPI_BRANCH = "dev"
SRCREV_machine = "ad7dc82fc5b05210f6873fac32bf574768a74050"

SRC_URI = " \
    git://github.com/waelkarman/linux.git;name=machine;branch=${LINUX_RPI_BRANCH};protocol=https \
    git://git.yoctoproject.org/yocto-kernel-cache;type=kmeta;name=meta;branch=${LINUX_RPI_KMETA_BRANCH};destsuffix=${KMETA};protocol=https \
    file://powersave.cfg \
    file://android-drivers.cfg \
    file://bunch-linux.cfg \
"

do_deploy:append() {
    install -m 0644 ${B}/.config ${DEPLOYDIR}/kernel.config
}
