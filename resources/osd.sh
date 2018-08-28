#!/bin/bash 

case "$1" in

filestore) 
# journal 
parted /dev/sdb --script -- mklabel gpt 
parted --script /dev/sdb mkpart primary 0MB 2420MB 
parted --script /dev/sdb mkpart primary 2421MB 4842MB 
sgdisk --zap-all --clear --mbrtogpt -g -- /dev/sdb1
sgdisk --zap-all --clear --mbrtogpt -g -- /dev/sdb2
ceph-volume lvm zap /dev/sdb1
ceph-volume lvm zap /dev/sdb2 

# data 
dd if=/dev/zero of=/dev/sdc  bs=1M count=1000
dd if=/dev/zero of=/dev/sdd  bs=1M count=1000
;;

*)
echo "Usage ./osd.sh filestore"
;;

esac 
