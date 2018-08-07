#!/bin/bash 
hostname=$(hostname)

if [ $hostname == controller ]; then 
ansible-playbook /vagrant/resources/ansible/controller.yml
else
ansible-playbook /vagrant/resources/ansible/default.yml
fi 
