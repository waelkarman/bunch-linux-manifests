SUMMARY = "Bunch Linux Demo is a demo to demonstrate the capabilities of the system"

inherit core-image
inherit populate_sdk_qt6
inherit extrausers

# To generate a valid pass: printf "%q" $(mkpasswd -m sha256crypt admin-nosexinthechurch)
PASSWD = "\$5\$YA7nDY0J\$th7S4jEgsrMeq45QCksPT6.gKk0Wqu3kO9xCgt7Yj43"

EXTRA_USERS_PARAMS = " \
    usermod -p '${PASSWD}' weston; \
"

IMAGE_FEATURES += " weston ssh-server-openssh tools-sdk debug-tweaks package-management hwcodecs tools-debug"

# CORE
IMAGE_INSTALL += " packagegroup-core-boot ${CORE_IMAGE_EXTRA_INSTALL}"
IMAGE_INSTALL += " u-boot u-boot-fw-utils systemd rauc"
IMAGE_INSTALL += " alsa-utils alsa-utils-alsatplg alsa-utils-aplay alsa-utils-amixer alsa-utils-alsamixer alsa-utils-speakertest alsa-utils-midi alsa-utils-aconnect alsa-utils-aseqnet alsa-utils-iecset alsa-utils-alsactl alsa-utils-aseqdump alsa-utils-alsaloop alsa-utils-alsaucm alsa-utils-scripts alsa-utils-nhltdmicinfo"
IMAGE_INSTALL += " mesa-demos mesa-megadriver libglapi libosmesa mesa-dev mesa-tools libgles3-mesa-dev libgles2-mesa libgles1-mesa libegl-mesa libgbm libgl-mesa mesa opengl-es-cts libdrm"
IMAGE_INSTALL += " gstreamer1.0-plugins-good gstreamer1.0-plugins-base gstreamer1.0-plugins-bad"
IMAGE_INSTALL += " gstreamer1.0 gstreamer1.0-dev gstreamer1.0-dbg gst-examples"
IMAGE_INSTALL += " gtk+3 gtk4"
IMAGE_INSTALL += " supplicant-service wpa-supplicant iw"
IMAGE_INSTALL += " pi-bluetooth python3-pybluez packagegroup-base-bluetooth " 
IMAGE_INSTALL += " python3 python3-pip python3-pyzmq"
IMAGE_INSTALL += " util-linux i2c-tools nano picocom rsync tree curl jq screen wget net-tools ntp parted htop cpufrequtils strace gdb"
IMAGE_INSTALL += " pi-blaster raspi-gpio rpi-gpio rpio libgpiod"
IMAGE_INSTALL += " xwayland weston-xwayland"

# QT LIBS
IMAGE_INSTALL += " packagegroup-qt6-essentials packagegroup-qt6-addons"

# CUSTOM
IMAGE_INSTALL += " webkitgtk"
IMAGE_INSTALL += " bunch-update neatvnc"
IMAGE_INSTALL += " sensors-app burger-app open-pipe-media-player custom-kernel-modules nautilus"
IMAGE_INSTALL += " systemdservices passivebuzzer-service button-service networkchecker-service icon-weston"