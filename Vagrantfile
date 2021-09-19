# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/xenial64" 

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
    vb.gui = true
  end   

  config.vm.define "master" do |master|
   master.vm.network "private_network", ip: "192.168.10.2", virtualbox__dhcp_server: false
   master.vm.hostname = "master"
   master.vm.provision "shell", path: "script.sh"
end
  
   config.vm.define "worker1" do |w1|
    w1.vm.network "private_network", type: "dhcp", virtualbox__dhcp_server: false
    w1.vm.hostname = "worker1"
    w1.vm.provision "shell", inline: <<-SHELL 
        # Debug ON!!!
        set -o xtrace
        sudo apt-get update
        sudo apt install -y dnsutils traceroute nmap       
        ifconfig
    SHELL
  end
end
