# GPU drivers for the Pi (vc4, v3d, broadcom) come from meta-raspberrypi.
PACKAGECONFIG:append = " \
    video-codecs \
    tools \
    ${@bb.utils.contains('DISTRO_FEATURES', 'vulkan', 'zink', '', d)} \
"
