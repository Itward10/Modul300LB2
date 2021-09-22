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


``` config.vm.box = "ubuntu/xenial64" ``` 

``` config.vm.network "forwarded_port", guest:80, host:8080, auto_correct: true``` Netzwerkeinstellung an der VM selber am besten schaltet man die automatisch dhcp verteilung von Virtualbox aus, wenn man selber einen DHCP Server erstellt. ``` virtualbox__dhcp_server: false ``` 

``` config.vm.provider "virtualbox" do |vb| ``` Auswahl der Virtualisierungssoftware 

``` 
    config.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end
```
Zusätzlich kann man die grössen der einzelnen Hardware Komponten definieren.

---
## Wenn man mehr als 1 VM aufsetzten möchte 

Dies kann man mit ```ruby config.vm.define "Name" do |Name| ```

Ein Beispiel für zwei vms:
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
---
## script

Wenn man alles in einem File möchte kann man unter den gewünschten vm zusätzlich hinschreiben:

```ruby

  config.vm.define "master" do |master|
    master.vm.network "private_network", ip: "192.168.50.2", virtualbox__dhcp_server: false
    master.vm.hostname = "master"
    master.vm.provision "shell", inline: <<-SHELL 
        # Debug ON!!!
        set -o xtrace
        sudo apt-get update
        sudo apt install -y isc-dhcp-server bind9 dnsutils traceroute nmap
        # DHCP Server
        cat <<%EOF% | sudo tee -a /etc/dhcp/dhcpd.conf
subnet 192.168.50.0 netmask 255.255.255.0 {
 range 192.168.50.20 192.168.50.100;
 option routers 192.168.50.254;
 option domain-name-servers 192.168.50.1;
 option domain-name "mydomain.example";
}
%EOF%

```
Die wichtigen Zeilen sind dabei ``` master.vm.provision "shell", inline: <<-SHELL # Debug ON!!! ```
Wenn man in eine configurationsdatei bearbeiten möchte:
```ruby
cat <<%EOF% | sudo tee -a /etc/dhcp/dhcpd.conf
subnet 192.168.10.0 netmask 255.255.254.0 {
range 192.168.10.50 192.168.10.100;
option routers 192.168.10.254;
option domain-name-servers 192.168.10.1;
option domain-name "mydomain.example";}
%EOF%
```
cat ist ein Schreibprogramm und %EOF% definiert was in den Text kommt.
Wenn man eine seperate Datei möchte für den script damit man die vms und script nach belieben wechseln kann man den folgenden code hinzufügen:
```master.vm.provision "shell", path: "script.sh" ```

Die script Datei ist im gleichen Ordner wie die Vagrant Datei, deshalb muss man den Pfad nicht angeben.


