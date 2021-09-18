# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|


    config.vm.box = "ubuntu/xenial64"
    config.vm.network "forwarded_port", guest:80, host:8080, auto_correct: true
    config.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end

    config.vm.provision "shell", path: "script.sh"

    config.vm.define "master" do |master|
        master.vm.network "private_network", ip: "192.168.1.1", virtualbox__dhcp_server: false
        master.vm.hostname = "master"
        end
    
    end