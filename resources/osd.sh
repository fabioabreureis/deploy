sudo parted -s /dev/sdb mklabel gpt mkpart primary xfs 0% 100%
sudo mkfs.xfs /dev/sdb -f
sudo parted -s /dev/sdc mklabel gpt mkpart primary xfs 0% 100%
sudo mkfs.xfs /dev/sdc -f
sudo parted -s /dev/sdd mklabel gpt mkpart primary xfs 0% 100%
sudo mkfs.xfs /dev/sdd -f
