#!/bin/bash

ip addr change 10.10.10.2/24 dev wlan0
route add default gw 10.10.10.1 dev wlan0
echo "nameserver 8.8.8.8" > /etc/resolv.conf
