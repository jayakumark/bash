#!/bin/bash
# CIS Level 1 Hardening Benchmark script for Ubuntu 14.04.2 LTS
# -Does not include Level 2 items
# -Please run with sudo or as root
#
# Key:
# *: Set by default / built into template config
# **: Not doing

# Contants
#RSYSLOG_REMOTE_HOST=""
ISSUE_BANNER='
     USE OF THIS COMPUTING SYSTEM IS RESTRICTED TO THE CONDUCT OF COMPANY
     BUSINESS BY AUTHORIZED USERS.  ALL INFORMATION AND COMMUNICATIONS ON THIS
     SYSTEM ARE SUBJECT TO REVIEW, MONITORING, AND RECORDING AT ANY TIME
     WITHOUT NOTICE.  UNAUTHORIZED ACCESS OR USE MAY BE SUBJECT TO PROSECUTION.
' # don't remove this

# 1.1 Install Updates, Patches and Additional Security Software (Not Scored)
apt-get update && apt-get upgrade -y

# 2.1 Create Separate Partition for /tmp (Scored) **
# 2.2 Set nodev option for /tmp Partition (Scored) **
# 2.3 Set nosuid option for /tmp Partition (Scored) **
# 2.4 Set noexec option for /tmp Partition (Scored) **
# 2.5 Create Separate Partition for /var (Scored) **

# 2.6 Bind Mount the /var/tmp directory to /tmp (Scored) **
# 2.7 Create Separate Partition for /var/log (Scored) **
# 2.8 Create Separate Partition for /var/log/audit (Scored) **
# 2.9 Create Separate Partition for /home (Scored) *
# 2.10 Add nodev Option to /home (Scored) *
# 2.11 Add nodev Option to Removable Media Partitions (Not Scored) **
# 2.12 Add noexec Option to Removable Media Partitions (Not Scored) **
# 2.13 Add nosuid Option to Removable Media Partitions (Not Scored) **
# 2.14 Add nodev Option to /run/shm Partition (Scored) *
# 2.15 Add nosuid Option to /run/shm Partition (Scored) *

# 2.16 Add noexec Option to /run/shm Partition (Scored)
echo "none     /run/shm     tmpfs     rw,noexec,nosuid,nodev     0     0" >> /etc/fstab

# 2.17 Set Sticky Bit on All World-Writable Directories (Scored)
df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type d -perm -0002 2>/dev/null | xargs chmod a+t

# 2.25 Disable Automounting (Scored) *
  # apt-get purge -y autofs

# 3.1 Set User/Group Owner on bootloader config (Scored)
chown root:root /boot/grub/grub.cfg

# 3.2 Set Permissions on bootloader config (Scored)
chmod og-rwx /boot/grub/grub.cfg

# 3.3 Set Boot Loader Password (Scored)
  # $ grub-mkpasswd-pbkdf2
  # $ cat <<EOF
  # $ set superusers="<user-list>"
  # $ password_pbkdf2 <user> <encrypted-password> EOF
  # $ # add this line to /etc/grub.d/10_linux : CLASS="--class gnu-linux --class gnu --class os --unrestricted"
  # $ update-grub
# 3.4 Require Authentication for Single-User Mode (Scored) *

# 4.1 Restrict Core Dumps (Scored)
sed -i 's/.*End of file.*/* hard core 0\n&/' /etc/security/limits.conf
echo "fs.suid_dumpable = 0" >> /etc/sysctl.conf
apt-get purge -y apport whoopsie

# 4.2 Enable XD/NX Support on 32-bit x86 Systems (Not Scored) *
# 4.3 Enable Randomized Virtual Memory Region Placement (Scored) *
  # echo 'kernel.randomize_va_space = 2' >> /etc/sysctl.conf
# 4.4 Disable Prelink (Scored) *
  # /usr/sbin/prelink -ua
  # apt-get purge -y prelink
# 5.1.1 Ensure NIS is not installed (Scored) *
  # apt-get purge -y nis
# 5.1.2 Ensure rsh server is not enabled (Scored) *
  # apt-get purge -y inetutils-inetd
# 5.1.3 Ensure rsh client is not installed (Scored) *
# 5.1.4 Ensure talk server is not enabled (Scored) *
# 5.1.5 Ensure talk client is not installed (Scored) *
# 5.1.6 Ensure telnet server is not enabled (Scored) *
# 5.1.7 Ensure tftp-server is not enabled (Scored) *
# 5.1.8 Ensure xinetd is not enabled (Scored) *
  # apt-get purge -y xinetd
# 5.2 Ensure chargen is not enabled (Scored) *
# 5.3 Ensure daytime is not enabled (Scored) *
# 5.4 Ensure echo is not enabled (Scored) *
# 5.5 Ensure discard is not enabled (Scored) *
# 5.6 Ensure time is not enabled (Scored) *
# 6.1 Ensure the X Window system is not installed (Scored) *
# 6.2 Ensure Avahi Server is not enabled (Scored) *
# 6.3 Ensure print server is not enabled (Not Scored) *
# 6.4 Ensure DHCP Server is not enabled (Scored) *

# 6.5 Configure Network Time Protocol (NTP) (Scored)
apt-get install -y ntp
sed -e '/server.*ubuntu/ s/^#*/#/' -i /etc/ntp.conf
echo "server ntp.starbucks.net" >> /etc/ntp.conf
  # echo "restrict -4 default kod notrap nomodify nopeer noquery" >> /etc/ntp.conf
  # echo "restrict -6 default kod notrap nomodify nopeer noquery" >> /etc/ntp.conf
service ntp restart

# 6.6 Ensure LDAP is not enabled (Not Scored) *
apt-get purge -y slapd

# 6.7 Ensure NFS and RPC are not enabled (Not Scored) *
# 6.8 Ensure DNS Server is not enabled (Not Scored) *
# 6.9 Ensure FTP Server is not enabled (Not Scored) *
# 6.10 Ensure HTTP Server is not enabled (Not Scored) *
# 6.11 Ensure IMAP and POP server is not enabled (Not Scored) *
# 6.12 Ensure Samba is not enabled (Not Scored) *
# 6.13 Ensure HTTP Proxy Server is not enabled (Not Scored) *
# 6.14 Ensure SNMP Server is not enabled (Not Scored) *
# 6.15 Configure Mail Transfer Agent for Local-Only Mode (Scored) *
# 6.16 Ensure rsync service is not enabled (Scored) *

# 6.17 Ensure Biosdevname is not enabled (Scored)
sudo apt-get purge -y biosdevname

# 7.1.1 Disable IP Forwarding (Scored) *
echo 'net.ipv4.ip_forward = 0' >> /etc/sysctl.conf
# 7.1.2 Disable Send Packet Redirects (Scored)
echo 'net.ipv4.conf.all.send_redirects = 0' >> /etc/sysctl.conf
echo 'net.ipv4.conf.default.send_redirects = 0' >> /etc/sysctl.conf
# 7.2.1 Disable Source Routed Packet Acceptance (Scored)
echo 'net.ipv4.conf.all.accept_source_route = 0' >> /etc/sysctl.conf
echo 'net.ipv4.conf.default.accept_source_route=0' >> /etc/sysctl.conf
# 7.2.2 Disable ICMP Redirect Acceptance (Scored)
echo 'net.ipv4.conf.all.accept_redirects = 0' >> /etc/sysctl.conf
echo 'net.ipv4.conf.default.accept_redirects = 0' >> /etc/sysctl.conf
# 7.2.3 Disable Secure ICMP Redirect Acceptance (Scored)
echo 'net.ipv4.conf.all.secure_redirects = 0' >> /etc/sysctl.conf
echo 'net.ipv4.conf.default.secure_redirects = 0' >> /etc/sysctl.conf
# 7.2.4 Log Suspicious Packets (Scored)
echo 'net.ipv4.conf.all.log_martians = 1' >> /etc/sysctl.conf
echo 'net.ipv4.conf.default.log_martians = 1' >> /etc/sysctl.conf
# 7.2.5 Enable Ignore Broadcast Requests (Scored) *
echo 'net.ipv4.icmp_echo_ignore_broadcasts = 1' >> /etc/sysctl.conf
# 7.2.6 Enable Bad Error Message Protection (Scored) *
echo 'net.ipv4.icmp_ignore_bogus_error_responses = 1' >> /etc/sysctl.conf
# 7.2.7 Enable RFC-recommended Source Route Validation (Scored) *
echo 'net.ipv4.conf.all.rp_filter = 1' >> /etc/sysctl.conf
echo 'net.ipv4.conf.default.rp_filter = 1' >> /etc/sysctl.conf
# 7.2.8 Enable TCP SYN Cookies (Scored)
echo 'net.ipv4.tcp_syncookies = 1' >> /etc/sysctl.conf
# 7.3.1 Disable IPv6 Router Advertisements (Not Scored)
echo 'net.ipv6.conf.all.accept_ra = 0' >> /etc/sysctl.conf
echo 'net.ipv6.conf.default.accept_ra = 0' >> /etc/sysctl.conf
# 7.3.2 Disable IPv6 Redirect Acceptance (Not Scored)
echo 'net.ipv6.conf.all.accept_redirects = 0' >> /etc/sysctl.conf
echo 'net.ipv6.conf.default.accept_redirects = 0' >> /etc/sysctl.conf
# 7.3.3 Disable IPv6 (Not Scored)
echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.lo.disable_ipv6 = 1' >> /etc/sysctl.conf

# 7.4.1 Install TCP Wrappers (Scored)
apt-get install -y tcpd

# 7.4.2 Create /etc/hosts.allow (Not Scored) *
# 7.4.3 Verify Permissions on /etc/hosts.allow (Scored) *
chmod 644 /etc/hosts.allow

# 7.4.4 Create /etc/hosts.deny (Not Scored)
touch /etc/hosts.deny
  # echo "ALL: ALL" >> /etc/hosts.deny

#7.4.5 Verify Permissions on /etc/hosts.deny (Scored) *
chmod 644 /etc/hosts.deny

# 7.5.1 Disable DCCP (Not Scored) *
# 7.5.2 Disable SCTP (Not Scored) *
# 7.5.3 Disable RDS (Not Scored) *
# 7.5.4 Disable TIPC (Not Scored) *
# 7.6 Deactivate Wireless Interfaces (Not Scored) *

# 7.7 Ensure Firewall is active (Scored)
ufw allow 22
ufw --force enable

# 8.2.1 Install the rsyslog package (Scored) *
# 8.2.2 Ensure the rsyslog Service is activated (Scored) *
initctl show-config rsyslog

# 8.2.3 Configure /etc/rsyslog.conf (Not Scored) *

# 8.2.4 Create and Set Permissions on rsyslog Log Files (Scored) **
# 8.2.5 Configure rsyslog to Send Logs to a Remote Log Host (Scored)
  # echo "*.* @@$RSYSLOG_REMOTE_HOST" >> /etc/rsyslog.conf

# 8.2.6 Accept Remote rsyslog Messages Only on Designated Log Hosts (Not Scored) *
# 9.1.1 Enable cron Daemon (Scored) *
initctl show-config cron
# 9.1.2 Set User/Group Owner and Permission on /etc/crontab (Scored)
chown root:root /etc/crontab
chmod og-rwx /etc/crontab
# 9.1.3 Set User/Group Owner and Permission on /etc/cron.hourly (Scored)
chown root:root /etc/cron.hourly
chmod og-rwx /etc/cron.hourly
# 9.1.4 Set User/Group Owner and Permission on /etc/cron.daily (Scored)
chown root:root /etc/cron.daily
chmod og-rwx /etc/cron.daily
# 9.1.5 Set User/Group Owner and Permission on /etc/cron.weekly (Scored)
chown root:root /etc/cron.weekly
chmod og-rwx /etc/cron.weekly
# 9.1.6 Set User/Group Owner and Permission on /etc/cron.monthly (Scored)
chown root:root /etc/cron.monthly
chmod og-rwx /etc/cron.monthly
# 9.1.7 Set User/Group Owner and Permission on /etc/cron.d (Scored)
chown root:root /etc/cron.d
chmod og-rwx /etc/cron.d

# 9.1.8 Restrict at/cron to Authorized Users (Scored)
rm /etc/cron.deny 2>/dev/null
rm /etc/at.deny  2>/dev/null
touch /etc/cron.allow
touch /etc/at.allow
chmod og-rwx /etc/cron.allow
chmod og-rwx /etc/at.allow
chown root:root /etc/cron.allow
chown root:root /etc/at.allow

# 9.2.1 Set Password Creation Requirement Parameters Using pam_cracklib (Scored)
echo "password required pam_cracklib.so retry=3 minlen=14 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1" >> /etc/pam.d/common-password

# 9.2.2 Set Lockout for Failed Password Attempts (Not Scored)
echo "auth required pam_tally2.so onerr=fail audit silent deny=5 unlock_time=900" >> /etc/pam.d/login

# 9.2.3 Limit Password Reuse (Scored)
echo "password sufficient pam_unix.so remember=5" >> /etc/pam.d/common-password

# 9.3.1 Set SSH Protocol to 2 (Scored) *
# 9.3.2 Set LogLevel to INFO (Scored) *
# 9.3.3 Set Permissions on /etc/ssh/sshd_config (Scored)
chown root:root /etc/ssh/sshd_config
chmod 600 /etc/ssh/sshd_config

# 9.3.4 Disable SSH X11 Forwarding (Scored)
sed -i '/X11Forwarding yes/c\X11Forwarding no' /etc/ssh/sshd_config

# 9.3.5 Set SSH MaxAuthTries to 4 or Less (Scored)
echo "MaxAuthTries 4" >> /etc/ssh/sshd_config

# 9.3.6 Set SSH IgnoreRhosts to Yes (Scored) *
# 9.3.7 Set SSH HostbasedAuthentication to No (Scored) *

# 9.3.8 Disable SSH Root Login (Scored)
sed -i '/PermitRootLogin without-password/c\PermitRootLogin no' /etc/ssh/sshd_config

# 9.3.9 Set SSH PermitEmptyPasswords to No (Scored) *
# 9.3.10 Do Not Allow Users to Set Environment Options (Scored)
echo "PermitUserEnvironment no" >> /etc/ssh/sshd_config

# 9.3.11 Use Only Approved Cipher in Counter Mode (Scored)
echo "Ciphers aes128-ctr,aes192-ctr,aes256-ctr" >> /etc/ssh/sshd_config

# 9.3.12 Set Idle Timeout Interval for User Login (Scored)
echo "ClientAliveInterval 300" >> /etc/ssh/sshd_config
echo "ClientAliveCountMax 0" >> /etc/ssh/sshd_config

# 9.3.13 Limit Access via SSH (Scored) **
# 9.3.14 Set SSH Banner (Scored)
sed -i '/^#.*Banner/s/^#//' /etc/ssh/sshd_config

# 9.4 Restrict root Login to System Console (Not Scored) *
# 9.5 Restrict Access to the su Command (Scored) **
  # echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su

# 10.1.1 Set Password Expiration Days (Scored)
sed -i -e '/PASS_MAX_DAYS.*[0-9]/s/.*/PASS_MAX_DAYS  90/' /etc/login.defs

# 10.1.2 Set Password Change Minimum Number of Days (Scored)
sed -i -e '/PASS_MIN_DAYS.*[0-9]/s/.*/PASS_MIN_DAYS  7/' /etc/login.defs

# 10.1.3 Set Password Expiring Warning Days (Scored) *
sed -i -e '/PASS_WARN_AGE.*[0-9]/s/.*/PASS_WARN_AGE  7/' /etc/login.defs

# 10.2 Disable System Accounts (Scored) *
  # Audit command:
  # egrep -v "^\+" /etc/passwd | awk -F: '($1!="root" && $1!="sync" && $1!="shutdown" && $1!="halt" && $3<500 && $7!="/usr/sbin/nologin" && $7!="/bin/false") {print}'
for user in `awk -F: '($3 < 500) {print $1 }' /etc/passwd`; do
  if [ $user != "root" ]
  then
    usermod -L $user 2>/dev/null
    if [ $user != "sync" ] && [ $user != "shutdown" ] && [ $user != "halt" ]
    then
      usermod -s nologin $user 2>/dev/null
    fi
  fi
done

# 10.3 Set Default Group for root Account (Scored) *
usermod -g 0 root 2>/dev/null

# 10.4 Set Default umask for Users (Scored) **
  # sed -i -e '/UMASK.*[0-9]/s/.*/UMASK  077/' /etc/login.defs
# 10.5 Lock Inactive User Accounts (Scored) **
  # useradd -D -f 35
# 11.1 Set Warning Banner for Standard Login Services (Scored)
touch /etc/motd
echo "$ISSUE_BANNER" > /etc/issue
echo "$ISSUE_BANNER" > /etc/issue.net
# echo "Environment is $(lsb_release -d | sed 's/Description://') ($(uname -sr))" >> /etc/motd
chown root:root /etc/motd
chmod 644 /etc/motd
chown root:root /etc/issue
chmod 644 /etc/issue
chown root:root /etc/issue.net
chmod 644 /etc/issue.net

# 11.2 Remove OS Information from Login Warning Banners (Scored) **
# 11.3 Set Graphical Warning Banner (Not Scored) **

# 12.1 Verify Permissions on /etc/passwd (Scored) *
chmod 644 /etc/passwd

# 12.2 Verify Permissions on /etc/shadow (Scored) *
chmod o-rwx,g-rw /etc/shadow
# 12.3 Verify Permissions on /etc/group (Scored) *
chmod 644 /etc/group
# 12.4 Verify User/Group Ownership on /etc/passwd (Scored) *
chown root:root /etc/passwd
# 12.5 Verify User/Group Ownership on /etc/shadow (Scored) *
chown root:shadow /etc/shadow
# 12.6 Verify User/Group Ownership on /etc/group (Scored) *
chown root:root /etc/group

# 12.7 Find World Writable Files (Not Scored) **
  # Check for files:
  # df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type f -perm -0002 -print

# 12.8 Find Un-owned Files and Directories (Scored) **
  # Check for files:
  # df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nouser -ls

# 12.9 Find Un-grouped Files and Directories (Scored) **
  # Check for files:
  # df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nogroup -ls

# 12.10 Find SUID System Executables (Not Scored) **
  # Check command:
  # df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type f -perm -4000 -print

# 12.11 Find SGID System Executables (Not Scored) **
  # Check command:
  # df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type f -perm -2000 -print

# 13.1 Ensure Password Fields are Not Empty (Scored) **
  # Check command:
  # cat /etc/shadow | awk -F: '($2 == "" ) { print $1 " does not have a password "}'

# 13.2 Verify No Legacy "+" Entries Exist in /etc/passwd File (Scored) **
# 13.3 Verify No Legacy "+" Entries Exist in /etc/shadow File (Scored) **
# 13.4 Verify No Legacy "+" Entries Exist in /etc/group File (Scored) **
# 13.5 Verify No UID 0 Accounts Exist Other Than root (Scored) **
  # Audit check (should only return root)
  # cat /etc/passwd | /usr/bin/awk -F: '($3 == 0) { print $1 }'

# 13.6 Ensure root PATH Integrity (Scored) *
# if [ "`echo $PATH | grep :: `" != "" ]; then
# 	echo "Empty Directory in PATH (::)"
# fi
# if [ "`echo $PATH | grep :$`" != "" ]; then
# 	echo "Trailing : in PATH"
# fi
# p=`echo $PATH | sed -e 's/::/:/' -e 's/:$//' -e 's/:/ /g'`
# set -- $p
# while [ "$1" != "" ]; do
# 	if [ "$1" = "." ]; then
# 		echo "PATH contains ."
# 	shift
# 	continue
# 	fi
# 	if [ -d $1 ]; then
# 	dirperm=`ls -ldH $1 | cut -f1 -d" "`
# 	if [ `echo $dirperm | cut -c6 ` != "-" ]; then
# 		echo "Group Write permission set on directory $1"
# 	fi
# 	if [ `echo $dirperm | cut -c9 ` != "-" ]; then
# 		echo "Other Write permission set on directory $1"
# 	fi
# 	dirown=`ls -ldH $1 | awk '{print $3}'`
# 	if [ "$dirown" != "root" ] ; then
# 		echo $1 is not owned by root
# 	fi
# 	else
# 	echo $1 is not a directory
# 	fi
# 	shift
# done

# 13.7 Check Permissions on User Home Directories (Scored) **
# 13.8 Check User Dot File Permissions (Scored) **
# 13.9 Check Permissions on User .netrc Files (Scored) **
# 13.10 Check for Presence of User .rhosts Files (Scored) **
# 13.11 Check Groups in /etc/passwd (Scored) **
# 13.12 Check That Users Are Assigned Valid Home Directories (Scored) **
# 13.13 Check User Home Directory Ownership (Scored) **
# 13.14 Check for Duplicate UIDs (Scored) **
# 13.15 Check for Duplicate GIDs (Scored) **
# 13.16 Check for Duplicate User Names (Scored) **
# 13.17 Check for Duplicate Group Names (Scored) **
# 13.18 Check for Presence of User .netrc Files (Scored) **
# 13.19 Check for Presence of User .forward Files (Scored) **

# 13.20 Ensure shadow group is empty (Scored) *
  # Audit check:
  # grep ^shadow /etc/group
  
  echo "Done.  Reboot recommended."