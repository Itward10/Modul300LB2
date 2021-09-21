# Dokumentation

Zuerst erstellten wir ein Vagrant File und das erste VM war ein Server. Unsere Idee war es wenn man ein neues Netzwerk aufbaut, 
dass man nur dieses vagrant ausführen kann und alle wichtige Dienste schon drauf sind. Einmal der DHCP und DNS Dienst.
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
Danach entschieden wir uns die Befehle in einen seperaten Script Datei zu wechseln.
![image](https://user-images.githubusercontent.com/89509863/134143506-4abf44e2-2764-497e-aed9-f609b845ee11.png)

Bei einem Testgang ist uns danach aufgefallen, dass wir gar nicht in unsere VMs zugreifen kann.
Wir suchten im Internet das Passwort und uns fiel auf, dass es nirgends steht. Überall stand eine Anleitung wie man eine SSH Passwort Setztung.
![image](https://user-images.githubusercontent.com/89509863/134144948-097a833b-da58-452a-b707-898b7440e80d.png)

Ich suchte in den Scripts herum der unser Lehrer als Beispiele gegeben hatte, habe ich Befehle Gefunden die zum Passwort setzten waren.
```ruby
      set -o xtrace
      sudo groupadd myadmin
      sudo useradd admin1 -g myadmin -m -s /bin/bash
      sudo chpasswd <<<admin1:admin

```
Ein User wurde erstellt namens admin1 und wurde zur admin Gruppe hinzugefügt. Zusätzlich wurde ein Passwort gesetzt admin.

