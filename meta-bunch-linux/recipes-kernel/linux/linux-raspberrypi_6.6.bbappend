FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://logo.cfg \
            file://0001-add-logo-bunch.patch \
            file://0002-increase-swiotlb-size.patch \
            "

