#!/bin/sh
# --- Imposta IP statico su wlan0 ---
ip addr flush dev wlan0
ip addr add 192.168.50.1/24 dev wlan0
ip link set wlan0 up

# --- Abilita IP forwarding ---
sysctl -w net.ipv4.ip_forward=1

# --- Configura NAT verso WireGuard ---
iptables -t nat -A POSTROUTING -o wg0 -j MASQUERADE
iptables -A FORWARD -i wlan0 -o wg0 -j ACCEPT
iptables -A FORWARD -i wg0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
