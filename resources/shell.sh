set -x
hostname=$(hostname)
keydir="/vagrant/resources/keys"


if [ $hostname == controller ]; then
        cp -Rv /vagrant/resources/keys/* /home/vagrant/.ssh/
        chown -R vagrant /home/vagrant/.ssh
fi

cat $keydir/id_rsa.pub >> /home/vagrant/.ssh/known_hosts
cat $keydir/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys

cp $keydir/ssh_known_hosts  /etc/ssh/
