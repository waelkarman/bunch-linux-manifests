# Bunch Linux desktop: bottom panel, custom background and app launchers.
# Icons and background come from weston-customization.
FILESEXTRAPATHS:prepend := "${THISDIR}/weston-init:"

# oe-core only sets a backend for QEMU: use DRM on the Pi as well
DEFAULTBACKEND = "drm"

RDEPENDS:${PN} += "weston-customization"

# QEMU (virtio-gpu):
# - the SDL window size becomes the preferred mode and drops out of the mode
#   list when the window is resized: pin a mode virtio-gpu always offers;
# - with atomic KMS virtio-gpu rejects Weston's updates ("requires full
#   modeset") after a host-side mode change and fbcon takes the screen back
#   (login prompt): use legacy KMS.
do_install:append:qemuall() {
	printf '\n[output]\nname=Virtual-1\nmode=1280x1024\n' >> ${D}${sysconfdir}/xdg/weston/weston.ini
	echo "WESTON_DISABLE_ATOMIC=1" >> ${D}${sysconfdir}/default/weston
}
