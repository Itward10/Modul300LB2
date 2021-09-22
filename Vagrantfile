# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
    vb.gui = true
  end   

  config.vm.define "main" do |main|
    main.vm.box = "ubuntu/xenial64" 
    main.vm.network "private_network", ip: "192.168.10.2", virtualbox__dhcp_server: false
    main.vm.hostname = "main"
    main.vm.provision "shell", path: "script.sh"
  end

  config.vm.define "Webserver" do |web|
    web.vm.box = "ubuntu/xenial64"
    web.vm.network "forwarded_port", guest:80, host:8080, auto_correct: true
    web.vm.hostname "private_network", "ip 192.168.10.3",  virtualbox__dhcp_server: false
    web.vm.hostname = "Webserver" 
    web.vm.provision "shell", inline: <<-SHELL 
    sudo apt-get update
    sudo apt-get -y install apache2 
  SHELL
end

  config.vm.define "worker1" do |w1|
    w1.vm.box = "ubuntu/xenial64" 
    w1.vm.provider "virtualbox"
    w1.vm.network "private_network", virtualbox__dhcp_server: false
    w1.vm.hostname = "worker1"
    w1.vm.provision "shell", inline: <<-SHELL 
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
