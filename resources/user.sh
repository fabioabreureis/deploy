useradd -d /home/ceph -m ceph
echo "ceph" | passwd --stdin ceph
echo "ceph ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ceph
chmod 0440 /etc/sudoers.d/ceph
sed -i s'/Defaults requiretty/#Defaults requiretty'/g /etc/sudoers
chown -R ceph.ceph /home/ceph
chmod -R 600 /home/ceph/.ssh/config
