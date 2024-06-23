
do_install:prepend() {

touch 10-dhcp.network
echo "[Match]
Name=wlan0

[Network]
DHCP=yes
LinkLocalAddressing=yes
IPv6AcceptRA=yes

[DHCP]
UseDNS=true
UseNTP=true
UseHostname=true" > "${WORKDIR}/10-dhcp.network"


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


do_install:append() {
    install -d ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/10-dhcp.network ${D}${sysconfdir}/systemd/network/10-dhcp.network
}

