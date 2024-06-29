PACKAGECONFIG:append:bunch-raspberrypi4-64 = " gbm"
PROVIDES:append:bunch-raspberrypi4-64 = " virtual/libgbm"

GALLIUMDRIVERS:append:bunch-raspberrypi4-64 = ",swrast"

do_install:append:bunch-raspberrypi4-64() {
    rm -rf ${D}${includedir}/KHR/khrplatform.h
}
