# -*- mode: ruby -*-
# vi: set ft=ruby :


# Interfaces
# eth0 - nat (used by VMware/VirtualBox)
# eth1 - br-mgmt (Container) 172.29.236.0/24
# eth2 - br-vlan (Neutron VLAN network) 0.0.0.0/0
# eth3 - host / API 192.168.100.0/24
# eth4 - br-vxlan (Neutron VXLAN Tunnel network) 172.29.240.0/24

network = '192.168.0'	
stornet = '10.10.10'
brmgmt = '172.29.236'
brvxlan = '172.29.240'

 
nodes = [
{ :hostname => 'client', :ip => "#{network}.10" , :ip2 =>  "#{stornet}.10"  },
{ :hostname => 'controller', :ip => "#{network}.115", :ip2 => "#{stornet}.115" , :ip3 => "#{brmgmt}.115" , :ip4 => "#{brvxlan}.115"  , :controller => 'yes' , :ram => 1024 , :sdb  => 'yes' , :multidev => 'yes' , :cephdeploy => 'yes' },
{ :hostname => 'compute1', :ip => "#{network}.116", :ip2 => "#{stornet}.116", :ip3 => "#{brmgmt}.116" , :ip4 => "#{brvxlan}.116"  , :cpu => 2 , :multidev => 'yes' , :ram => 2048 },
{ :hostname => 'compute2', :ip => "#{network}.117", :ip2 => "#{stornet}.117" , :ip3 => "#{brmgmt}.117" , :ip4 => "#{brvxlan}.117" , :cpu => 2 , :multidev => 'yes' , :ram => 2048 },
{ :hostname => 'network', :ip => "#{network}.118", :ip2 => "#{stornet}.118" , :ip3 => "#{brmgmt}.118" , :ip4 => "#{brvxlan}.118" , :multidev => 'yes' , :ram => 1024 },
{ :hostname => 'deploy', :ip => "#{network}.114", :ip2 => "#{stornet}.114" , :ip3 => "#{brmgmt}.114" , :ip4 => "#{brvxlan}.114"  , :controller => 'yes', :multidev => 'yes' },
{ :hostname => 'rgw-node1', :ip => "#{network}.12" , :ip2 => "#{stornet}.12"  },
{ :hostname => 'rgw-node2', :ip => "#{network}.13" , :ip2 => "#{stornet}.13"  },
{ :hostname => 'rgw-node3', :ip => "#{network}.14" , :ip2 => "#{stornet}.14" },
{ :hostname => 'mon1', :ip => "#{network}.100" , :ip2 => "#{stornet}.100"  },
{ :hostname => 'mon2', :ip => "#{network}.101" , :ip2 => "#{stornet}.101"  },
{ :hostname => 'mon3', :ip => "#{network}.102" , :ip2 => "#{stornet}.102"  },
{ :hostname => 'osd1', :ip => "#{network}.103" , :ip2 => "#{stornet}.103"  , :ram => 512, :osd => 'yes' },
{ :hostname => 'osd2', :ip => "#{network}.104", :ip2 => "#{stornet}.103"  , :ram => 512, :osd => 'yes' },
{ :hostname => 'osd3', :ip => "#{network}.105", :ip2 => "#{stornet}.103"  , :ram => 512, :osd => 'yes' }]


Vagrant.configure("2") do |config|
		nodes.each do |node|
			config.vm.define node[:hostname] do |nodeconfig|
				nodeconfig.vm.box = "centos/7"
				nodeconfig.vm.hostname = node[:hostname]
				nodeconfig.vm.network :private_network, ip: node[:ip]
				nodeconfig.vm.network :private_network, ip: node[:ip2]
				memory = node[:ram] ? node[:ram] : 512;
                       		cpu = node[:cpu] ? node[:cpu] : 1;


                     	       if node[:multidev] == "yes"
                               	 nodeconfig.vm.network :private_network, ip: node[:ip3]
				 nodeconfig.vm.network :private_network, ip: node[:ip4]
			       end

			       if node[:hostname] == "controller"
                                  nodeconfig.vm.network "forwarded_port", guest: 80, host: 8080, protocol: "tcp"
				end


         	nodeconfig.vm.provider :virtualbox do |vb|
			vb.customize [ "modifyvm", :id, "--memory", memory.to_s,]
                        config.vm.provision "shell", inline: "yum -y install git tunctl bridge-utils ansible"
			nodeconfig.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
			nodeconfig.vm.synced_folder "resources", "/resources", disabled: true
			nodeconfig.vm.provision "shell", path: "post.sh"
				
			if node[:sdb] == "yes"
                                   vb.customize ["storagectl", :id, "--add", "sata", "--name", "SATA" , "--portcount", 4, "--hostiocache", "on"]
                                   vb.customize [ "createhd", "--filename", "disk_sata-#{node[:hostname]}", "--size", "40960" ]
                                   vb.customize [ "storageattach", :id, "--storagectl", "SATA", "--port", 2, "--device", 0, "--type", "hdd", "--medium", "disk_sata-#{node[:hostname]}.vdi" ]
                                end                     



			if node[:osd] == "yes"
				vb.customize ["storagectl", :id, "--add", "sata", "--name", "OSD" , "--portcount", 4, "--hostiocache", "on"]
				vb.customize [ "createhd", "--filename", "disk_osd1-#{node[:hostname]}", "--size", "5192" ]
				vb.customize [ "storageattach", :id, "--storagectl", "OSD", "--port", 2, "--device", 0, "--type", "hdd", "--medium", "disk_osd1-#{node[:hostname]}.vdi" ]
				vb.customize [ "createhd", "--filename", "disk_osd2-#{node[:hostname]}", "--size", "5192" ]
				vb.customize [ "storageattach", :id, "--storagectl", "OSD", "--port", 3, "--device", 0, "--type", "hdd", "--medium", "disk_osd2-#{node[:hostname]}.vdi" ]
				vb.customize [ "createhd", "--filename", "disk_osd3-#{node[:hostname]}", "--size", "5192" ]
				vb.customize [ "storageattach", :id, "--storagectl", "OSD", "--port", 4, "--device", 0, "--type", "hdd", "--medium", "disk_osd3-#{node[:hostname]}.vdi" ]

				end
			end
		end
	end
end
#end
