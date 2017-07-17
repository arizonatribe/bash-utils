#!/bin/bash

if [ -z $1 ] ; then
  echo "Usage: $0 <username>"
  exit 2
fi

if [[ ! $1 =~ ^([A-Z]|[a-z])([a-z]|[0-9]){3,19}$ ]] ; then
  echo "Usernames should only contain alpha-numeric characters and span between 4 and 20 characters in length"
  exit 1
fi

useradd $1
pword=$(pwgen -y1s 12)
echo "Inital password is $pword"
echo $1:$pword | chpasswd
mkdir -p /home/$1/.ssh

if [ ! -z "$2" ] ; then
  echo "$2" >> /home/$1/.ssh/authorized_keys
else
  touch /home/$1/.ssh/authorized_keys
fi

chmod 700 /home/$1/.ssh
chmod 600 /home/$1/.ssh/authorized_keys
chown -R $1:$1 /home/$1/.ssh

exit 0

