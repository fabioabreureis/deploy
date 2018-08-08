# -*- mode: ruby -*-
# vi: set ft=ruby :

network = '192.168.0'	

nodes = [
{ :hostname => 'client', :ip => "#{network}.10" },
{ :hostname => 'controller', :ip => "#{network}.15" , :ram => 1024, :packstack => 'yes' , :cephdeploy: 'yes' },
{ :hostname => 'compute', :ip => "#{network}.16", :cpu => 2 , :ram => 2048 },
{ :hostname => 'network', :ip => "#{network}.17", :ram => 1024 },
{ :hostname => 'mon1', :ip => "#{network}.100" },
{ :hostname => 'mon2', :ip => "#{network}.101" },
{ :hostname => 'mon3', :ip => "#{network}.102"},
{ :hostname => 'rgw-node1', :ip => "#{network}.12" },
{ :hostname => 'rgw-node2', :ip => "#{network}.13" },
{ :hostname => 'rgw-node3', :ip => "#{network}.14" },
{ :hostname => 'osd1', :ip => "#{network}.103", :ram => 512, :osd => 'yes' },
{ :hostname => 'osd2', :ip => "#{network}.104", :ram => 512, :osd => 'yes' },
{ :hostname => 'osd3', :ip => "#{network}.105", :ram => 512, :osd => 'yes' }]

Vagrant.configure("2") do |config|
		nodes.each do |node|
			config.vm.define node[:hostname] do |nodeconfig|
				nodeconfig.vm.box = "centos/7"
				nodeconfig.vm.hostname = node[:hostname]
				nodeconfig.vm.network :private_network, ip: node[:ip]
				memory = node[:ram] ? node[:ram] : 512;
                       		cpu = node[:cpu] ? node[:cpu] : 1;

         	nodeconfig.vm.provider :virtualbox do |vb|
			vb.customize [ "modifyvm", :id, "--memory", memory.to_s,]
                        config.vm.provision "shell", inline: "yum -y install ansible"
			nodeconfig.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
			nodeconfig.vm.synced_folder "ansible", "/ansible", disabled: true
			config.vm.provision "shell", inline: "sudo /vagrant/resources/shell.sh"
			nodeconfig.vm.provision "shell", path: "post.sh" ,run: "always"
                     
			 if node[:hostname] == "controller"
                                 config.vm.network "forwarded_port", guest: 80, host: 80
                        end

			 if node[:hostname] == "mon1"
                                 config.vm.network "forwarded_port", guest: 7789, host: 7789
                        end

			if node[:packstack] == "yes"
				config.vm.provision "shell", inline: " ansible-playbook /vagrant/resources/ansible/packstack.yml"
			end
			
			if node[:osp] == "yes"
  				  config.disksize.size = '80GB'
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
