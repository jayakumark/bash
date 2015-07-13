#!/bin/bash
#
# Interactive Ubuntu Init
#
# This should probably be moved to a config management tool.

AD_DOMAIN="cloud.com"
AD_OU="OU=DefaultComputers,DC=cloud,DC=com"

read -p "AD bind username: " adusername

sudo apt-get install realmd sssd samba-common samba-common-bin samba-libs sssd-tools krb5-user adcli packagekit -y

sudo realm -v join -U $adusername $AD_DOMAIN --computer-ou=$AD_OU

cat > sssdconf <<EOF
[sssd]
default_domain_suffix = $AD_DOMAIN
[$AD_DOMAIN]
ldap_idmap_range_size = 800000
EOF
echo -e $sssdconf > /etc/sssd/sssd.conf

sudo initctl stop sssd

# remove the sssd cache because it was generated with the wrong id map size
sudo rm /var/lib/sss/db/cache_cloud.com.ldb

sudo initctl start sssd

# modify /etc/pam.d/common-session add line above pam_unix.so line
sudo sed -i '/pam_unix.so/i \session optional        pam_mkhomedir.so' /etc/pam.d/common-session

# Modify sudoers for sudo access

# Use the realm permit commands to grant access
sudo realm permit user@$AD_DOMAIN or sudo realm permit -g groupname@$AD_DOMAIN
