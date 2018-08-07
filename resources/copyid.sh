set -x
hostname=$(hostname)
keydir="/vagrant/resources/keys"


if [ $hostname == controller ]; then
		for i in $(cat listshell); do 
		  sudo 	sshpass -p "vagrant" ssh-copy-id -o StrictHostKeyChecking=no $i
		done


fi
