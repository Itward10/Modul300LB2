# Vagrant anwendung

Vagrant ist eine Software die dazu dient für einfache Softwareverteilung. Auf der Vagrant Website findet man allerlei Packete zur Installation von Betriebssysteme. Sie ist eine kommunikation zwischen Virtualisierungssoftware und Systemkonfigurationswerkzeuge. 

Zuerst erstellt man ein Ordner und dort drinnen Vagrant File. Dieses fängt man an mit:

```ruby

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
end

```

In diesem Beispiel oben nehme ich das Paket ubuntu/xenial64.
Dies findet man auch auf ihrer offizielle Website:
![image](https://user-images.githubusercontent.com/89509863/133934602-d33b479a-b156-4f5d-96eb-6cb683dfa686.png)

Vagrant zieht das Packet runter auf den Lokalen PC/Server und setzt die vm auf.

Mit dem **config.vm** Namensraum kann man die konfiguration bestimmen von der vm selber.


```ruby config.vm.box = "ubuntu/xenial64" ``` 

```ruby config.vm.network "forwarded_port", guest:80, host:8080, auto_correct: true``` Netzwerkeinstellung an der VM selber

```ruby config.vm.provider "virtualbox" do |vb| ``` Auswahl der Virtualisierungssoftware 

```ruby 
    config.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end
```
Zusätzlich kann man die grössen der einzelnen Hardware Komponten definieren.

---
## Wenn man mehr als 1 VM aufsetzten möchte 

Dies kann man mit ```ruby config.vm.define "Name" do |Name| ```

Ein Beispiel für zwei vms einmal einen Server und einen client:
```ruby

config.vm.define "master" do |master|
   master.vm.network "private_network", ip: "192.168.10.2", virtualbox__dhcp_server: false
   master.vm.hostname = "master"
   master.vm.provision "shell", path: "script.sh"
  end
  
   config.vm.define "worker1" do |w1|
    w1.vm.network "private_network", type: "dhcp",  name: "vboxnet0", virtualbox__dhcp_server: false
    w1.vm.hostname = "worker1"
    w1.vm.provision "shell", inline: <<-SHELL 
        # Debug ON!!!
        set -o xtrace
        sudo apt-get update
        sudo apt install -y dnsutils traceroute nmap       
        ifconfig
    SHELL
  end
  ```

