#!/bin/bash

sudo  echo "" >/etc/resolv.conf
sudo echo "search lab.cephbrasil.com" >>/etc/resolv.conf
sudo echo "nameserver 192.168.0.115" >> /etc/resolv.conf
sudo echo "nameserver 8.8.8.8" >> /etc/resolv.conf


if [ -f /etc/sysconfig/network-scripts/ifcfg-br-mgmt ]; then
sudo ifdown br-mgmt
fi 

if [ -f /etc/sysconfig/network-scripts/ifcfg-eth2 ]; then
sudo ifdown eth2
fi

if [ -f /etc/sysconfig/network-scripts/ifcfg-br-storage ]; then
sudo ifdown br-storage
fi

if [ -f /etc/sysconfig/network-scripts/ifcfg-br-vlan ]; then
sudo ifdown br-vlan
fi 

if [ -f /etc/sysconfig/network-scripts/ifcfg-br-vxlan ]; then 
sudo ifdown br-vxlan 
fi 

if [ -f /etc/sysconfig/network-scripts/ifcfg-eth3 ]; then
sudo ifdown eth3
fi 

if [ -f /etc/sysconfig/network-scripts/ifcfg-eth3.235 ]; then
sudo ifdown eth3.236
fi 

if [ -f /etc/sysconfig/network-scripts/ifcfg-eth4 ]; then
sudo ifdown eth4
fi 

if [ -f /etc/sysconfig/network-scripts/ifcfg-eth4.240 ]; then 
sudo ifdown eth4.240
fi 

sudo rm -rf /etc/sysconfig/network-scripts/ifcfg-eth2*
sudo rm -rf /etc/sysconfig/network-scripts/ifcfg-eth3* 
sudo rm -rf /etc/sysconfig/network-scripts/ifcfg-eth4*
sudo rm -rf /etc/sysconfig/network-scripts/ifcfg-br*

sudo cat > /etc/sysconfig/network-scripts/ifcfg-eth3<<EOF
DEVICE=eth3
TYPE=Ethernet
BOOTPROTO=none
ONBOOT=yes
NM_CONTROLLED=no
EOF

if [ -f /etc/sysconfig/network-scripts/ifcfg-eth3 ]; then
sudo ifup eth3
fi

sudo cat > /etc/sysconfig/network-scripts/ifcfg-eth3.236<<EOF
DEVICE=eth3.236
TYPE=Ethernet
BOOTPROTO=none
ONBOOT=yes
VLAN=yes
BRIDGE=br-mgmt
NM_CONTROLLED=no
EOF

if [ -f /etc/sysconfig/network-scripts/ifcfg-eth3.236 ]; then
sudo ifup eth3.236
fi

sudo cat > /etc/sysconfig/network-scripts/ifcfg-eth4<<EOF
DEVICE=eth4
TYPE=Ethernet
BOOTPROTO=none
ONBOOT=yes
BRIDGE=br-vlan
NM_CONTROLLED=no
EOF

if [ -f /etc/sysconfig/network-scripts/ifcfg-eth4 ]; then
sudo ifup eth4
fi


sudo cat > /etc/sysconfig/network-scripts/ifcfg-eth4.240<<EOF
DEVICE=eth4.240
TYPE=Ethernet
BOOTPROTO=none
ONBOOT=yes
VLAN=yes
BRIDGE=br-vxlan
NM_CONTROLLED=no
EOF

if [ -f /etc/sysconfig/network-scripts/ifcfg-eth4.240 ]; then
sudo ifup eth4.240
fi

sudo cat > /etc/sysconfig/network-scripts/ifcfg-eth2<<EOF
DEVICE=eth2
TYPE=Ethernet
BOOTPROTO=none
ONBOOT=yes
BRIDGE=br-storage
NM_CONTROLLED=no
EOF

if [ -f /etc/sysconfig/network-scripts/ifcfg-eth2 ]; then
sudo ifup eth2
fi


sudo cat > /etc/sysconfig/network-scripts/ifcfg-br-storage<<EOF
DEVICE=br-storage
TYPE=Bridge
BOOTPROTO=static
ONBOOT=yes
IPADDR=10.10.10.$1
NETMASK=255.255.255.0
EOF

if [ -f /etc/sysconfig/network-scripts/ifcfg-br-storage ]; then
sudo ifup br-storage
fi


sudo cat > /etc/sysconfig/network-scripts/ifcfg-br-mgmt<<EOF
DEVICE=br-mgmt
TYPE=Bridge
BOOTPROTO=static
ONBOOT=yes
IPADDR=172.29.236.$1
NETMASK=255.255.255.0
EOF


if [ -f /etc/sysconfig/network-scripts/ifcfg-br-mgmt ]; then
sudo ifup br-mgmt
fi

sudo cat > /etc/sysconfig/network-scripts/ifcfg-br-vxlan<<EOF
DEVICE=br-vxlan
TYPE=Bridge
BOOTPROTO=static
ONBOOT=yes
IPADDR=172.29.240.$1
NETMASK=255.255.255.0
EOF

if [ -f /etc/sysconfig/network-scripts/ifcfg-br-vxlan ]; then
sudo ifup br-vxlan
fi
sudo cat > /etc/sysconfig/network-scripts/ifcfg-br-vlan<<EOF
DEVICE=br-vlan
TYPE=Bridge
BOOTPROTO=none
ONBOOT=yes
DELAY=0
EOF

if [ -f /etc/sysconfig/network-scripts/ifcfg-br-vlan ]; then
sudo ifup br-vlan
fi

