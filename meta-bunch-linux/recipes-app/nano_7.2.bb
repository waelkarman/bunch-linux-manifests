# Recipe created by recipetool
# This is the basis of a recipe and may need further editing in order to be fully functional.
# (Feel free to remove these comments when editing.)

# WARNING: the following LICENSE and LIC_FILES_CHKSUM values are best guesses - it is
# your responsibility to verify that the values are complete and correct.
#
# The following license files were not able to be identified and are
# represented as "Unknown" below, you will need to check them yourself:
#   COPYING.DOC
#
# NOTE: multiple licenses have been detected; they have been separated with &
# in the LICENSE value for now since it is a reasonable assumption that all
# of the licenses apply. If instead there is a choice between the multiple
# licenses then you should change the value to separate the licenses with |
# instead of &. If there is any doubt, check the accompanying documentation
# to determine which situation is applicable.
LICENSE = "CLOSED"
LIC_FILES_CHKSUM = "file://COPYING;md5=f27defe1e96c2e1ecd4e0c9be8967949 \
                    file://COPYING.DOC;md5=ad1419ecc56e060eccf8184a87c4285f"

SRC_URI = "https://www.nano-editor.org/dist/v7/nano-${PV}.tar.xz"
SRC_URI[md5sum] = "13742c686c6ddb0b7b294634f0c13cec"
SRC_URI[sha1sum] = "00f5b15ba12843c38fa8f9dd3076eea943853c0a"
SRC_URI[sha256sum] = "86f3442768bd2873cec693f83cdf80b4b444ad3cc14760b74361474fc87a4526"
SRC_URI[sha384sum] = "beada56c37b5c671649ab9c1029e3c5b91435aa0a54f1d9fc01e453660ca5a289fe05cbc37e18f160cdba0bd3bcea4bc"
SRC_URI[sha512sum] = "a6dfa70edab62e439a9a998ca214f2415d57dbdc01766ad2e4b14048836557a32755f8b09de13c6a89023f215b61d2854017b389eae8d097ca6f3ba73ce2f583"

# NOTE: the following library dependencies are unknown, ignoring: curses
#       (this is based on recipes that have previously been built and packaged)
DEPENDS = "file ncurses zlib"

# NOTE: if this software is not capable of being built in a separate build directory
# from the source, you should replace autotools with autotools-brokensep in the
# inherit line
inherit pkgconfig gettext autotools

# Specify any options you want to pass to the configure script using EXTRA_OECONF:
EXTRA_OECONF = ""

python do_display_banner() {
    bb.plain("*  Install nano text editor ............    *");
}

addtask display_banner after do_install