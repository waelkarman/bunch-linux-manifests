
do_install:prepend() {
echo  "ctrl_interface=/var/run/wpa_supplicant
ctrl_interface_group=0
update_config=1

network={
ssid=\"FRITZ!Box 7583 KW\"
scan_ssid=1
key_mgmt=WPA-PSK
psk=\"23587684732970795127\"
}" > "${WORKDIR}/wpa_supplicant.conf-sane"
}
