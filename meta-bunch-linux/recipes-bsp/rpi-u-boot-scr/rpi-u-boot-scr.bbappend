
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

echo \"       ---WELCOME TO BUNCH_LINUX---\"
echo \"            .-/+oossssoo+/-.               waelkarman@waelkarman  \"
echo \"         :+ssssssssssssssssss+:            ---------------------  \"
echo \"      -+ssssssssssssssssssyyssss+-         OS: Ubuntu 20.04.6 LTS x86_64  \"
echo \"    .ossssssssssssssssssdMMMNysssso.       Host: Precision 5570  \"
echo \"   /ssssssssssshdmmNNmmyNMMMMhssssss/      Kernel: 5.15.0-91-generic  \"
echo \"  +ssssssssshmydMMMMMMMNddddyssssssss+     Uptime: 5 hours, 25 mins  \"
echo \" /sssssssshNMMMyhhyyyyhmNMMMNhssssssss/    Packages: 2339 (dpkg), 14 (snap)  \"
echo \".ssssssssdMMMNhsssssssssshNMMMdssssssss.   Shell: bash 5.0.17  \"
echo \"+sssshhhyNMMNyssssssssssssyNMMMysssssss+   Resolution: 2560x1600, 2560x1440, 2560x1440  \"
echo \"ossyNMMMNyMMhsssssssssssssshmmmhssssssso   DE: GNOME  \"
echo \"ossyNMMMNyMMhsssssssssssssshmmmhssssssso   WM: Mutter  \"
echo \"+sssshhhyNMMNyssssssssssssyNMMMysssssss+   WM Theme: Adwaita  \"
echo \".ssssssssdMMMNhsssssssssshNMMMdssssssss.   Theme: Yaru [GTK2/3]  \"
echo \" /sssssssshNMMMyhhyyyyhdNMMMNhssssssss/    Icons: Yaru [GTK2/3]  \"
echo \"  +sssssssssdmydMMMMMMMMddddyssssssss+     Terminal: x-terminal-emul  \"
echo \"   /ssssssssssshdmNNNNmyNMMMMhssssss/      CPU: 12th Gen Intel i9-12900H (20) @ 4.900GHz  \"
echo \"    .ossssssssssssssssssdMMMNysssso.       GPU: NVIDIA 01:00.0 NVIDIA Corporation Device 25ba  \"
echo \"      -+sssssssssssssssssyyyssss+-         GPU: Intel Device 46a6  \"
echo \"         :+ssssssssssssssssss+:            Memory: 8571MiB / 31762MiB  \"
echo \"            .-/+oossssoo+/-. \"
                                                                   

fdt addr \${fdt_addr} && fdt get value default_bootargs /chosen bootargs
setenv bootargs \"\${default_bootargs} \${bootargs} rootfstype=ext4 rootwait\"
fatload mmc 0:1 \${kernel_addr_r} @@KERNEL_IMAGETYPE@@
if test ! -e mmc 0:1 uboot.env; then saveenv; fi;
@@KERNEL_BOOTCMD@@ \${kernel_addr_r} - \${fdt_addr}" > "${WORKDIR}/boot.cmd.in"
}
