SUMMARY = "Bunch Linux Demo is a demo to demonstrate the capabilities of the system"

inherit core-image
inherit extrausers

EXTRA_USERS_PARAMS += "groupadd i2c; groupadd spi; groupadd gpio;"

IMAGE_FEATURES += "${BUNCH_OPTIONAL_IMAGE_FEATURES}"

# CORE
IMAGE_INSTALL += " packagegroup-core-boot ${CORE_IMAGE_EXTRA_INSTALL}"
IMAGE_INSTALL += " u-boot u-boot-fw-utils systemd rauc"
IMAGE_INSTALL += " supplicant-service wpa-supplicant iw"
IMAGE_INSTALL += " pi-bluetooth python3-pybluez packagegroup-base-bluetooth " 
IMAGE_INSTALL += " python3 python3-pip python3-pyzmq"
IMAGE_INSTALL += " util-linux i2c-tools nano picocom rsync tree curl jq screen wget net-tools ntp parted htop cpufrequtils strace gdb"
IMAGE_INSTALL += " libgpiod raspi-gpio"

# Alsa / Gstreamer
#IMAGE_INSTALL += " alsa-utils gstreamer1.0 gstreamer1.0-plugins-good gstreamer1.0-plugins-base gstreamer1.0-plugins-bad gst-examples"

# QT LIBS
#inherit populate_sdk_qt6
#IMAGE_INSTALL += " packagegroup-qt6-essentials"

# GTK LIBS
#IMAGE_INSTALL += " gtk+3 gtk4"

# VPN BRIDGE
IMAGE_INSTALL += " wireguard-tools dnsmasq iptables hostapd iproute2"

# CUSTOM
#IMAGE_INSTALL += " bunch-update custom-kernel-modules "

