SUMMARY = "Bunch Linux core packages and features"

inherit core-image

IMAGE_FEATURES += " ssh-server-openssh tools-sdk debug-tweaks package-management hwcodecs tools-debug"

IMAGE_INSTALL += " pi-bluetooth bluez5 iw wpa-supplicant rsync"
IMAGE_INSTALL += " parted util-linux screen lsof wget net-tools ntp u-boot-fw-utils u-boot base-files"
IMAGE_INSTALL += " systemd tree i2c-tools nano rauc jq v4l-utils curl" 
IMAGE_INSTALL += " raspi-gpio pi-blaster libgpiod-dev rpi-gpio rpio"
IMAGE_INSTALL += " python3-pyzmq python3 python3-pip"
IMAGE_INSTALL += " supplicant-service wpa-supplicant"

