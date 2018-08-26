 #!/bin/bash
hostname=$(hostname)
keydir="/vagrant/resources/keys"

function copyid(){
if [ $hostname == controller ]; then
                for i in $(cat listshell); do
                        sshpass -p "vagrant" ssh-copy-id -f -o StrictHostKeyChecking=no $i
                done
fi
}


if [ $hostname == controller ]; then
        cp -Rv /vagrant/resources/keys/* /home/vagrant/.ssh/
        sudo chown -R vagrant /home/vagrant/.ssh
        sudo chmod 600  /home/vagrant/.ssh/id_rsa
fi

cat $keydir/id_rsa.pub >> /home/vagrant/.ssh/known_hosts
cat $keydir/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

for i in $(cat listshell); do
ssh-keyscan $i $keydir/ssh_known_hosts
done

sudo cp $keydir/ssh_known_hosts  /etc/ssh/

if [ $? == 0 ] ; then
copyid
fi


