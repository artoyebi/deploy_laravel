# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
	
	# Ubuntu Focal Fossa
    config.vm.define "Master" do |ubuntu|
      ubuntu.vm.box = "ubuntu/focal64"
      ubuntu.vm.hostname = "ubuntu"
      ubuntu.vm.network "private_network", type: "dhcp"
      ubuntu.vm.network "forwarded_port", guest: 80, host: 8081
      ubuntu.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
      end
    end
	
    # Debian Buster
    config.vm.define "Slave" do |slave|
      slave.vm.box = "ubuntu/focal64"
      slave.vm.hostname = "slave"
      slave.vm.network "private_network", type: "dhcp"
      slave.vm.network "forwarded_port", guest: 80, host: 8082
      slave.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
      end
    end

  end
  