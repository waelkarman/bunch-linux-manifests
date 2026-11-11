#!/bin/sh
# Prepare wlan0 for the hotspot. Safe to run more than once.
set -e

# Static address of the access point
ip addr replace 192.168.50.1/24 dev wlan0
ip link set wlan0 up

# Route hotspot clients through the WireGuard tunnel
sysctl -q -w net.ipv4.ip_forward=1

# rule TABLE CHAIN ARGS...: append the rule only if it is not there yet
rule() {
    table=$1; chain=$2; shift 2
    iptables -t "$table" -C "$chain" "$@" 2>/dev/null || iptables -t "$table" -A "$chain" "$@"
}
rule nat    POSTROUTING -o wg0 -j MASQUERADE
rule filter FORWARD -i wlan0 -o wg0 -j ACCEPT
rule filter FORWARD -i wg0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
