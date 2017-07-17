#!/bin/bash
 
# Check the username
if [ -z $1 ] ; then
  echo "Usage: $0 <username>"
  exit 2
fi
 
# Create the user and set their password
useradd $1
pword=$(pwgen -y1s 12)
echo "Inital password for $1 is $pword"
echo $1:$pword | chpasswd
space_suffix='_demo'
jailspace=$1$space_suffix
 
# Carve out a directory on the host for the jail
mkdir /opt/$jailspace
 
# Install basic tools needed in the jail
jk_init -v /opt/$jailspace ssh basicshell netbasics extendedshell jk_lsh
 
# Install additional files/tools
jk_cp -v -f /opt/$jailspace/ /etc/bashrc
 
# Bind an existing user account to this jail
jk_jailuser -m -j /opt/$jailspace/ $1
 
# Setup SSH
test -d /opt/$jailspace/home/$1/.ssh || mkdir -p /opt/$jailspace/home/$1/.ssh
 
# install the pub key (passed in as an argument)
if [ ! -z "$2" ] ; then
  echo "$2" >> /opt/$jailspace/home/$1/.ssh/authorized_keys
else
  touch /opt/$jailspace/home/$1/.ssh/authorized_keys
fi
 
# Set ownership and read/write/execute permissions
chmod 700 /opt/$jailspace/home/$1/.ssh
chmod 600 /opt/$jailspace/home/$1/.ssh/authorized_keys
chown -R $1:$1 /opt/$jailspace/home/$1/.ssh
 
# Change the default shell for the jailed user
sed -i s@/usr/sbin/jk_lsh@/bin/bash@g /opt/$jailspace/etc/passwd
 
# Get the UID for this new user so we can set the firewalld restrictions
demoUID=$(awk -F":" -v pattern=$1 ' $0 ~ pattern {print $3} ' /etc/passwd)
 
exit 0
