#Passwort setzen
set -o xtrace
sudo apt-get update
sudo groupadd myadmin
sudo useradd admin2 -g myadmin -m -s /bin/bash
sudo chpasswd <<<admin2:admin






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
