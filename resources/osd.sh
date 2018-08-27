sudo parted --script /dev/sdb mklabel gpt mkpart primary xfs 1MB 1500MB mkpart primary xfs 1501MB 3000MB mkpart primary xfs 3001MB 4500MB
sudo mkfs.xfs /dev/sdb1 -f
sudo mkfs.xfs /dev/sdb2 -f
sudo mkfs.xfs /dev/sdb3 -f
sudo parted -s /dev/sdc mklabel gpt mkpart primary xfs 0% 100%
sudo mkfs.xfs /dev/sdc -f
sudo parted -s /dev/sdd mklabel gpt mkpart primary xfs 0% 100%
sudo mkfs.xfs /dev/sdd -f
