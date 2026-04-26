PACKAGECONFIG:append = " \
    gallium \
    video-codecs \
    ${@bb.utils.filter('DISTRO_FEATURES', 'x11 vulkan wayland', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'opengl', 'opengl egl gles gbm virgl', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland opengl', 'dri3', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11 opengl', 'dri3', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11 vulkan', 'dri3', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'vulkan', 'zink', '', d)} \
    tools \
    osmesa \
"
