#!/bin/sh

rfkill unblock all
ip link set wlan0 down
ip link set eth0 down
ip link set wlan0 up
ip link set eth0 up
wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant.conf
udhcpc -i wlan0