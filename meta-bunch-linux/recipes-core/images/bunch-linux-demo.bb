SUMMARY = "Bunch Linux Demo is a demo to demonstrate the capabilities of the system"
LICENSE = "MIT"

inherit core-image
inherit extrausers

EXTRA_USERS_PARAMS += "groupadd i2c; groupadd spi; groupadd gpio;"

# Debug conveniences and tools come from the distro configuration
# (BUNCH_DEBUG_MODE / BUNCH_PRODUCTION_MODE / BUNCH_ENABLE_ALL_FEATURES).
IMAGE_FEATURES += "${BUNCH_IMAGE_FEATURES}"

# CORE
IMAGE_INSTALL += " packagegroup-core-boot ${CORE_IMAGE_EXTRA_INSTALL}"
# kernel-image: the A/B boot script loads the kernel from /boot of the slot.
# u-boot: ships /etc/fw_env.config, needed by fw_setenv (RAUC U-Boot backend).
IMAGE_INSTALL += " kernel-image u-boot libubootenv-bin rauc"
IMAGE_INSTALL += " pi-bluetooth python3-pybluez packagegroup-base-bluetooth"
IMAGE_INSTALL += " python3 python3-pip python3-pyzmq"
IMAGE_INSTALL += " util-linux i2c-tools nano picocom rsync tree curl jq screen wget net-tools parted htop cpufrequtils"
IMAGE_INSTALL += " libgpiod raspi-gpio"

# Alsa / Gstreamer
#IMAGE_INSTALL += " alsa-utils gstreamer1.0 gstreamer1.0-plugins-good gstreamer1.0-plugins-base gstreamer1.0-plugins-bad gst-examples"

# QT LIBS
#inherit populate_sdk_qt6
#IMAGE_INSTALL += " packagegroup-qt6-essentials"

# GTK LIBS
#IMAGE_INSTALL += " gtk+3 gtk4"

# NETWORK: role of wlan0 chosen by BUNCH_WLAN_MODE (see the distro conf)
IMAGE_INSTALL += " iw iproute2"
IMAGE_INSTALL += "${@' hostapd dnsmasq iptables wireguard-tools' if d.getVar('BUNCH_WLAN_MODE') == 'ap' else ' wifi-client-config'}"

# CUSTOM
#IMAGE_INSTALL += " bunch-update custom-kernel-modules "
