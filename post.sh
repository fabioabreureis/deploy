#/bin/bash 
hostname=$(hostname)
resources="/vagrant/resources"

if [ ! -f ~/runonce ]; then 

	if [ $hostname == controller ]; then 
	sudo $resources/network.sh 115
	sleep 5
	ansible-playbook $resources/ansible/controller.yml
	else
	ansible-playbook $resources/ansible/default.yml
	fi 


	if [ $hostname == compute1 ]; then 
	sudo $resources/network.sh 116
	fi 

	if [ $hostname == compute2 ]; then 
	sudo $resources/network.sh 117
	fi 

	if [ $hostname == network ]; then 
	cd /vagrant/resources
	sudo $resources/network.sh 118

  touch ~/runonce
	fi
sudo $resources/shell.sh
fi 
