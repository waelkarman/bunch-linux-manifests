PACKAGECONFIG ??= " \
    ${@bb.utils.filter('DISTRO_FEATURES', 'wayland x11 vulkan', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'opengl wayland', 'wayland', '', d)} \
    gstreamer \
    cups \
    iso-codes \
"
