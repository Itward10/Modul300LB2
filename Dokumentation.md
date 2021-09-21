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
Ein User wurde erstellt namens admin1 und wurde zur admin Gruppe hinzugefügt. Zusätzlich wurde ein Passwort gesetzt admin. Danach dachten wir nach was man noch in einem Netz brauchen, der zum ersten mal aufgesetzt wird. Ich dachte an einen AD Server, aber ich wollte alles Linux basiert haben, da ich meiner Meinung nach zu wenig weiss.Damit unser Vagrant File nicht voller script sprach ist entschieden wir uns für ein seperates File. Damit man die Script Files nach belieben in anderen Projekten zu implementieren.

```script
#!/usr/bin/env bash
sudo -s
## Install openldap
yum -y install openldap compat-openldap openldap-clients openldap-servers openldap-servers-sql openldap-devel
systemctl start slapd.service
systemctl enable slapd.service00
cd /etc/openldap/
## Configure Openldap — db.ldif
echo “dn: olcDatabase={2}hdb,cn=config” >> db.ldif
echo “changetype: modify” >> db.ldif
echo “replace: olcSuffix” >> db.ldif
echo “olcSuffix: dc=Labor,dc=Test,dc=com” >> db.ldif
echo “” >> db.ldif
echo “dn: olcDatabase={2}hdb,cn=config” >> db.ldif
echo “changetype: modify” >> db.ldif
echo “replace: olcRootDN” >> db.ldif
echo “olcRootDN: cn=ldapadm,dc=Labor,dc=Test,dc=com” >> db.ldif
echo “” >> db.ldif
echo “dn: olcDatabase={2}hdb,cn=config” >> db.ldif
echo “changetype: modify” >> db.ldif
echo “replace: olcRootPW” >> db.ldif
password=$(slappasswd -s password)
echo “olcRootPW: $password” >> db.ldif
echo “dn: dc=Labor,dc=Test,dc=com” >> base.ldif
echo “dc: Labor” >> base.ldif
echo “objectClass: top” >> base.ldif
echo “objectClass: domain” >> base.ldif
echo “” >> base.ldif
echo “dn: cn=ldapadm,dc=Labor,dc=Test,dc=com” >> base.ldif
echo “objectClass: organizationalRole” >> base.ldif
echo “cn: ldapadm” >> base.ldif
echo “description: LDAP Manager” >> base.ldif
echo “” >> base.ldif
echo “dn: ou=People,dc=Labor,dc=Tests,dc=com” >> base.ldif
echo “objectClass: organizationalUnit” >> base.ldif
echo “ou: People” >> base.ldif
echo “” >> base.ldif
echo “dn: ou=Group,dc=Labor,dc=Test,dc=com” >> base.ldif
echo “objectClass: organizationalUnit” >> base.ldif
echo “ou: Group” >> base.ldif

#User Konfiguration
echo “dn: uid=Sarah,ou=People,dc=Labor,dc=Tests, dc=com” >> users.ldif
echo “objectClass: top” >> users.ldif
echo “objectClass: person” >> users.ldif
echo “objectClass: shadowAccount” >> users.ldif
echo “cn: Sarah” >> users.ldif
echo “uid: Sarah” >> users.ldif
password=$(slappasswd -s Saraht123)
echo “userPassword: $password” >> users.ldif
echo “” >> users.ldif
echo “dn: uid=Muriel,ou=People,dc=Labor,dc=Tests, dc=com” >> users.ldif
echo “objectClass: top” >> users.ldif
echo “objectClass: person” >> users.ldif
echo “objectClass: shadowAccount” >> users.ldif
echo “cn: Muriel” >> users.ldif
echo “sn: Greyjoy” >> users.ldif
echo “uid: Muriel” >> users.ldif
password=$(slappasswd -s Muriel123)
echo “userPassword: $password” >> users.ldif


echo “dn: dc=Labor,dc=Tests,dc=com” >> base.ldif
echo “dc: Labor” >> base.ldif
echo “objectClass: top” >> base.ldif
echo “objectClass: domain” >> base.ldif
echo “” >> base.ldif
echo “dn: cn=ldapadm,dc=Labor,dc=Tests,dc=com” >> base.ldif
echo “objectClass: organizationalRole” >> base.ldif
echo “cn: ldapadm” >> base.ldif
echo “description: LDAP Manager” >> base.ldif
echo “” >> base.ldif
echo “dn: ou=People,dc=Labor,dc=Tests,dc=com” >> base.ldif
echo “objectClass: organizationalUnit” >> base.ldif
echo “ou: People” >> base.ldif
echo “” >> base.ldif
echo “dn: ou=Group,dc=Labor,dc=Tests,dc=com” >> base.ldif
echo “objectClass: organizationalUnit” >> base.ldif
echo “ou: Group” >> base.ldif

#Sarah und Muriel zur Admin Gruppe hinzugefügt
echo “dn: cn=admin,ou=Group,dc=Labor,dc=Tests,dc=com” >> userGroups.ldif
echo “changetype: modify” >> userGroups.ldif
echo “add: memberUid” >> userGroups.ldif
echo “memberUid: uid=Sarah,ou=People,dc=Labor,dc=Tests,dc=com” >> userGroups.ldif
echo “” >> userGroups.ldif
echo “dn: cn=oper,ou=Group,dc=Labor,dc=Tests,dc=com” >> userGroups.ldif
echo “changetype: modify” >> userGroups.ldif
echo “add: memberUid” >> userGroups.ldif
echo “memberUid: uid=Muriel,ou=People,dc=Labor,dc=Tests,dc=com” >> userGroups.ldif

#Konfiguration übernehmen
ldapmodify -Y EXTERNAL -H ldapi:/// -f db.ldif
cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
chown -R ldap:ldap /var/lib/ldap
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif
ldapadd -x -w WinterIsComing -D “cn=ldapadm,dc=Labor,dc=Tests,dc=com” -f base.ldif
ldapadd -x -w WinterIsComing -D “cn=ldapadm,dc=Labor,dc=Tests,dc=com” -f users.ldif
ldapadd -x -w WinterIsComing -D “cn=ldapadm,dc=Labor,dc=Tests,dc=com” -f groups.ldif
ldapadd -x -w WinterIsComing -D “cn=ldapadm,dc=Labor,dc=Tests,dc=com” -f userGroups.ldif

``` 
Dies habe ich mit einer Vorlage gemacht und meine Daten hinzugefügt. 
