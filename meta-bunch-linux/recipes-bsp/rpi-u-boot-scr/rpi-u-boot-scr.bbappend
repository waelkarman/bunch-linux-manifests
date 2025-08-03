
do_compile:prepend() {

   echo "test -n \"\${BOOT_ORDER}\" || setenv BOOT_ORDER \"A B\"
test -n \"\${BOOT_A_LEFT}\" || setenv BOOT_A_LEFT 3
test -n \"\${BOOT_B_LEFT}\" || setenv BOOT_B_LEFT 3

setenv bootargs
for BOOT_SLOT in \"\${BOOT_ORDER}\"; do
if test \"x\${bootargs}\" != \"x\"; then
    # skip remaining slots
elif test \"x\${BOOT_SLOT}\" = \"xA\"; then
    if test 0x\${BOOT_A_LEFT} -gt 0; then
    echo \"Found valid slot A, \${BOOT_A_LEFT} attempts remaining\"
    setexpr BOOT_A_LEFT \${BOOT_A_LEFT} - 1
    #setenv load_kernel \"nand read \${kernel_loadaddr} \${kernel_a_nandoffset} \${kernel_size}\"
    setenv bootargs \"\${default_bootargs} root=/dev/mmcblk0p2 rauc.slot=A\"
    fi
elif test \"x\${BOOT_SLOT}\" = \"xB\"; then
    if test 0x\${BOOT_B_LEFT} -gt 0; then
    echo \"Found valid slot B, \${BOOT_B_LEFT} attempts remaining\"
    setexpr BOOT_B_LEFT \${BOOT_B_LEFT} - 1
    #setenv load_kernel \"nand read \${kernel_loadaddr} \${kernel_b_nandoffset} \${kernel_size}\"
    setenv bootargs \"\${default_bootargs} root=/dev/mmcblk0p3 rauc.slot=B\"
    fi
fi
done

if test -n \"\${bootargs}\"; then
saveenv
else
echo \"No valid slot found, resetting tries to 3\"
setenv BOOT_A_LEFT 3
setenv BOOT_B_LEFT 3
saveenv
reset
fi                 

fdt addr \${fdt_addr} && fdt get value default_bootargs /chosen bootargs
setenv bootargs \"\${default_bootargs} \${bootargs} rootfstype=ext4 rootwait\"
fatload mmc 0:1 \${kernel_addr_r} @@KERNEL_IMAGETYPE@@
if test ! -e mmc 0:1 uboot.env; then saveenv; fi;
@@KERNEL_BOOTCMD@@ \${kernel_addr_r} - \${fdt_addr}" > "${WORKDIR}/boot.cmd.in"
}
