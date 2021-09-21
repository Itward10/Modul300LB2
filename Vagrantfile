# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
    vb.gui = true
  end   

  config.vm.define "master1" do |master1|
    master1.vm.box = "ubuntu/xenial64" 
    master1.vm.network "private_network", ip: "192.168.10.2", virtualbox__dhcp_server: false
    master1.vm.hostname = "master1"
    master1.vm.provision "shell", path: "script.sh"
  end


  config.vm.define "master2" do |master2|
    master2.vm.box = "centos/7"
    master2.vm.network "private_network", ip: "192.168.10.3", virtualbox__dhcp_server: false
    master2.vm.hostname = "master2"
    master2.vm.provision "shell", path: "LDAP.sh"
  end
    
  config.vm.define "worker1" do |w1|
    w1.vm.box = "ubuntu/xenial64" 
    w1.vm.provider "virtualbox"
    w1.vm.network "private_network", virtualbox__dhcp_server: false
    w1.vm.hostname = "worker1"
    w1.vm.provision "shell", inline: <<-SHELL 
        # Debug ON!!!
        set -o xtrace
        sudo apt-get update
        sudo apt install -y dnsutils traceroute nmap       
        ifconfig
        sudo groupadd myadmin
        sudo useradd User -g myadmin -m -s /bin/bash
        sudo chpasswd <<<User:User
        SHELL
    end
end
