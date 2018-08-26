Ceph Brasil Laboratory
======================

## Requirements

Hardware for the lab : 

* 8 Gb de RAM 
* 2 Core CPU 


A computer with these tools installed : 

* Vagrant and plugin hostname manager <https://www.vagrantup.com/downloads.html>
* Virtual Box <https://www.virtualbox.org/wiki/Downloads>


## Introduction

This lab make a provision of these components : 

* 3 Mons
* 3 OSDs
* 3 openstack nodes - compute,network and controller 
* 3 Rados Gateway 
* 1 VM Client for labs 

We can controll some behaviours if set the variable into the Vagrantfile : 


Into the directory resources we have all scripts and playbooks involved with provision of machines.


## Topology 

![Alt text](ceph-brasil-lab.png?raw=true "Lab Ceph Brasil")


The ssh access is from the controller server with ssh user key of vagrant or root, if you need up a Ceph Lab, you need provision the mons, osds and controller vms for example.  


 
