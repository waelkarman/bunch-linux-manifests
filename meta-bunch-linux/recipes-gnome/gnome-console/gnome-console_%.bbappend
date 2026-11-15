# kgx 47.1 aborts with GTK 4.22 ("gdk_display_manager_get() was called
# before gtk_init()"): initialise libadwaita at the start of main().
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://0001-main-call-adw_init-before-creating-the-application.patch"
