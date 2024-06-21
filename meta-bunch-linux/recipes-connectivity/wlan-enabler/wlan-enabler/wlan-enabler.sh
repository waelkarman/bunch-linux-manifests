#!/bin/sh

echo "nameserver 8.8.8.8" > /etc/resolv.conf
rfkill unblock all
ip link set wlan0 up
wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant.conf
udhcpc -i wlan0