PACKAGECONFIG:remove:bunch-raspberrypi4-64 = "${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', 'fbdev', '', d)}"

EXTRA_OECONF:append:bunch-raspberrypi4-64 = " \
    --disable-xwayland-test \
    --disable-simple-egl-clients \
    ${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', '', ' \
        --disable-resize-optimization \
        --disable-setuid-install \
    ', d)} \
"
