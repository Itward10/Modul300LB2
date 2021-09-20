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
echo “dc: KingsLanding” >> base.ldif
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
echo “dn: uid=Robert,ou=People,dc=KingsLanding, dc=Westeros, dc=com” >> users.ldif
echo “objectClass: top” >> users.ldif
echo “objectClass: person” >> users.ldif
echo “objectClass: shadowAccount” >> users.ldif
echo “cn: Robert” >> users.ldif
echo “sn: Baratheon” >> users.ldif
echo “uid: Robert” >> users.ldif
password=$(slappasswd -s Robert123)
echo “userPassword: $password” >> users.ldif
echo “” >> users.ldif
echo “dn: uid=Theon,ou=People,dc=KingsLanding, dc=Westeros, dc=com” >> users.ldif
echo “objectClass: top” >> users.ldif
echo “objectClass: person” >> users.ldif
echo “objectClass: shadowAccount” >> users.ldif
echo “cn: Theon” >> users.ldif
echo “sn: Greyjoy” >> users.ldif
echo “uid: Theon” >> users.ldif
password=$(slappasswd -s Theon123)
echo “userPassword: $password” >> users.ldif