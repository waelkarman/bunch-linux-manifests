# QEMU only (the Pi uses linux-raspberrypi): USB webcam support for object-detector.
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append:qemuall = " file://webcam.cfg"
