#!/bin/bash

echo -n "Enter IP [ ens33 ]: "
read ens33IP
echo -n "Enter IP [ ens34 ]: "
read ens34IP
echo -n "Gateway [192.168.0.1]: "
read gate
echo -n "DNS [192.168.0.1]: "
read dns


cat > /etc/sysconfig/network-scripts/ifcfg-br-ex <<EOL
DEVICE=br-ex
ONBOOT=yes
DEVICETYPE=ovs
TYPE=OVSIntPort
OVS_BRIDGE=br-ex
IPADDR=$ens33IP
NETMASK=255.255.255.0
GATEWAY=$gate
DNS1=8.8.8.8
DNS2=$dns
EOL

cat > /etc/sysconfig/network-scripts/ifcfg-ens33 <<EOL
DEVICE=ens33
ONBOOT=yes
NETBOOT=yes
IPV6INIT=no
BOOTPROTO=none
NAME=ens33
DEVICETYPE=ovs
TYPE=OVSPort
OVS_BRIDGE=br-ex
EOL

cat > /etc/sysconfig/network-scripts/ifcfg-ens34 <<EOL
TYPE="Ethernet"
BOOTPROTO="static"
DEFROUTE="yes"
PEERDNS="yes"
PEERROUTES="yes"
IPADDR="$ens34IP"
NETMASK="255.255.255.0"
IPV6INIT="yes"
NAME="ens34"
DEVICE="ens34"
ONBOOT="yes"
EOL


cat > /etc/sysctl.conf <<EOL
net.ipv4.ip_forward=1
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.default.rp_filter=0
EOL

sysctl -p
