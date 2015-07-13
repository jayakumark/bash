#!/bin/bash
#
# Ubuntu Server AD Bind script using SSSD
# -Please run with sudo
# -Interactive due to realm join password prompt

# Parameters - change these accordingly
AD_DOMAIN="cloud.com"
AD_OU="OU=Servers,OU=Cloud,DC=cloud,DC=net"
AD_GROUPS=("Standard Access" "Admin Access")
AD_USERS=("svc_acc1" "svc_acc2")
BIND_ACC="svc-joiner"

## Script

# Check if sudo
if [[ $(id -u) -ne 0 ]] ; then
  echo "Please re-run this script with sudo / as root. Exiting..."
  exit 1
fi

# Install dependencies
apt-get update
apt-get install -y realmd sssd samba-common samba-common-bin samba-libs sssd-tools krb5-user adcli packagekit

# Bind to domain
echo "Using account, $BIND_ACC, to join AD domain, $AD_DOMAIN.  You will be prompted for password:"
realm --verbose join -U $BIND_ACC $AD_DOMAIN --computer-ou=$AD_OU
if [ $? -eq 1 ] ; then
  echo "Realm join failed.  Exiting..."
  exit 1
fi

# Add pam_mkhomedir.so to pam config
sed -i '/pam_unix.so/i \session optional        pam_mkhomedir.so' /etc/pam.d/common-session

# Update sssd.conf and restart it
initctl stop sssd
sed -i "/services = nss, pam/a default_domain_suffix = $AD_DOMAIN" /etc/sssd/sssd.conf
# sed -i -e '/use_fully_qualified_names = True/ s/^#*/# /' /etc/sssd/sssd.conf
echo "entry_cache_timeout = 43200" >> /etc/sssd/sssd.conf
rm -vf "/var/lib/sss/db/cache_${AD_DOMAIN,,}.ldb"
initctl start sssd

# Wait for the cache to build
echo "Sleeping a few seconds for cache rebuild..."
sleep 10

# Use the realm permit commands to grant access and add to /etc/sudoers
for ((i = 0; i < ${#AD_GROUPS[@]}; i++))
do
  realm permit -g "${AD_GROUPS[$i]}@$AD_DOMAIN"
  echo ${AD_GROUPS[$i]} | sed 's/ /\\ /g' | awk -v domain="$AD_DOMAIN" '{print "%"$0"@"domain"     ALL=(ALL:ALL) ALL"}' >> /etc/sudoers
done

for ((i = 0; i < ${#AD_USERS[@]}; i++))
do
  realm permit "${AD_USERS[$i]}@$AD_DOMAIN"
done

echo "Done."
