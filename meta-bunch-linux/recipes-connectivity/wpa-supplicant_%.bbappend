
do_install:prepend() {

touch 10-dhcp.network
echo "[Match]
Name=wlan0
country=IT


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
ssid=\"waelkarman\"
scan_ssid=1
key_mgmt=WPA-PSK
psk=\"waelwael\"
}" > "${WORKDIR}/wpa_supplicant.conf-sane"
}


do_install:append() {
    install -d ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/10-dhcp.network ${D}${sysconfdir}/systemd/network/10-dhcp.network
}

