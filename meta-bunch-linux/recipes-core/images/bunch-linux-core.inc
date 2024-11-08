SUMMARY = "Bunch Linux core packages and features"

inherit core-image

IMAGE_FEATURES += " weston ssh-server-openssh tools-sdk debug-tweaks package-management hwcodecs tools-debug"

# NOT CONFIGURED
IMAGE_INSTALL += " weston-xwayland"

# CONFIGURED
IMAGE_INSTALL += " u-boot u-boot-fw-utils systemd rauc"
IMAGE_INSTALL += " alsa-utils alsa-utils-alsatplg alsa-utils-aplay alsa-utils-amixer alsa-utils-alsamixer alsa-utils-speakertest alsa-utils-midi alsa-utils-aconnect alsa-utils-aseqnet alsa-utils-iecset alsa-utils-alsactl alsa-utils-aseqdump alsa-utils-alsaloop alsa-utils-alsaucm alsa-utils-scripts alsa-utils-nhltdmicinfo"
IMAGE_INSTALL += " mesa-demos mesa-megadriver libglapi libosmesa mesa-dev mesa-tools libgles3-mesa-dev libgles2-mesa libgles1-mesa libegl-mesa libgbm libgl-mesa mesa opengl-es-cts libdrm"
IMAGE_INSTALL += " gstreamer1.0-plugins-good gstreamer1.0-plugins-base gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad-opencv gstreamer1.0-omx"
IMAGE_INSTALL += " gstreamer1.0 gstreamer1.0-dev gstreamer1.0-dbg gstreamer1.0-libav ffmpeg gst-examples"
IMAGE_INSTALL += " gtk+3 gtk4"
IMAGE_INSTALL += " supplicant-service wpa-supplicant iw"
IMAGE_INSTALL += " pi-bluetooth python3-pybluez packagegroup-base-bluetooth " 
IMAGE_INSTALL += " python3 python3-pip python3-pyzmq"
IMAGE_INSTALL += " util-linux i2c-tools nano picocom rsync tree curl jq screen wget net-tools ntp parted htop cpufrequtils strace gdb"
IMAGE_INSTALL += " pi-blaster raspi-gpio rpi-gpio rpio libgpiod"
IMAGE_INSTALL += " xwayland"