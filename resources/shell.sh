 #!/bin/bash
hostname=$(hostname)
keydir="/vagrant/resources/keys"

function copyid(){
if [ $hostname == controller ]; then
                for i in $(cat listshell); do
                        sshpass -p "vagrant" ssh-copy-id -f -o StrictHostKeyChecking=no $i
                        sshpass -p "vagrant" ssh-copy-id -f -o StrictHostKeyChecking=no root@$i

sudo -kSs << EOF
sshpass -p "vagrant" $keydir/ssh-copy-id -f -o StrictHostKeyChecking=no root@$i
EOF
                done
fi
}


if [ $hostname == controller ]; then
        cp -Rv /vagrant/resources/keys/* /home/vagrant/.ssh/
        chown -R vagrant /home/vagrant/.ssh
        sudo cp  -Rv /vagrant/resources/keys/* /root/.ssh/
fi

cat $keydir/id_rsa.pub >> /home/vagrant/.ssh/known_hosts
cat $keydir/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

sudo -kSs << EOF
cat $keydir/id_rsa.pub >> /root/.ssh/known_hosts
cat$keydir/id_rsa.pub >> /root/.ssh/authorized_keys
EOF


for i in $(cat listshell); do
ssh-keyscan $i $keydir/ssh_known_hosts
done

sudo cp $keydir/ssh_known_hosts  /etc/ssh/

if [ $? == 0 ] ; then
copyid
fi

