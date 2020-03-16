#!/bin/bash

if [ $(id -u) != 0 ]; then
    echo "must run as root!" >&2
    exit 1
fi

ip addr change 10.10.10.1/24 dev wlan1

# Enable ipv4/ipv6 forwarding
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv6.conf.all.forwarding=1

iptables -A FORWARD -i wlan1 -o wlan0 -j ACCEPT
iptables -A FORWARD -i wlan0 -o wlan1 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
