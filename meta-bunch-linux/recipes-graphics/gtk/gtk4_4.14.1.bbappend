PACKAGECONFIG ??= "gstreamer ${@bb.utils.filter('DISTRO_FEATURES', 'wayland x11 vulkan', d)}\
                        x11 wayland cups iso-codes gstreamer \
                        "