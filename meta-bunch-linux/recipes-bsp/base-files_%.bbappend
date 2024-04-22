
do_install:append () {
    cat >> ${D}${sysconfdir}/fstab <<EOF

# mount boot part
/dev/mmcblk0p1  /boot   vfat    defaults    0   0

EOF
}