#standard commands
set -o xtrace
sudo apt-get update

#installation
sudo apt-get -y install apache2
sudo apt install -y isc-dhcp-server bind9 dnsutils traceroute nmap

#Passwort setzen        
      set -o xtrace
      sudo groupadd myadmin
      sudo useradd admin1 -g myadmin -m -s /bin/bash
      sudo chpasswd <<<admin1:admin
      


# DHCP config Datei bearbeiten
cat <<%EOF% | sudo tee -a /etc/dhcp/dhcpd.conf
subnet 192.168.10.0 netmask 255.255.254.0 {
range 192.168.10.50 192.168.10.100;
option routers 192.168.10.254;
option domain-name-servers 192.168.10.1;
option domain-name "mydomain.example";}
%EOF%
sudo sed -i -e 's/INTERFACES=""/INTERFACES="enp0s8"/g' /etc/default/isc-dhcp-server
sudo systemctl restart isc-dhcp-server.service  

# DNS Server
sudo cp /vagrant/named.conf.local /etc/bind/
sudo cp /vagrant/db.example.com /vagrant/db.192  /var/lib/bind/
sudo systemctl restart bind9.service
