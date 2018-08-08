Ceph Brasil Laboratory
======================

## Introduction

This lab make a provision of these components : 

* 3 Mons
* 3 OSDs
* 3 openstack nodes - compute,network and controller 
* 3 Rados Gateway 
* 1 VM Client for labs 

We can controll some behaviours if set the variable into the Vagrantfile : 

* packstack - yes = start the packstack deploy during the vm provision. 
* cephdeploy - yes = start the packstack deploy during the vm provision. <= Not implemented at this time


Into the directory resources we have all scripts and playbooks involved with provision of machines.


## Topology 

![Alt text](ceph-brasil-lab.png?raw=true "Lab Ceph Brasil")


The ssh access is from the controller server with ssh user key of vagrant or root, if you need up a Ceph Lab, you need provision the mons, osds and controller vms for example.  


 
