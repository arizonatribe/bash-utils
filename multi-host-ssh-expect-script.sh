#!/usr/bin/bash

# Parse SSH Host to connect to (this should also match a stored entry in your LastPass safe)
ssh_host=$1
if [[ -z $ssh_host ]]
then
	echo "You must provide an ssh host to connect to"
	return
fi

# Lookup the SSH password for this host, stored in your LastPass account (be sure to install lastpass-cli)
EXTRACTED_PASSWORD=$(lpass show --password $ssh_host)
if [[ -z $EXTRACTED_PASSWORD ]]
then
	echo "Unable to find password matching $ssh_host"
	return
fi

# Now, spawn off the SSH connection and respond to the Password confirmation request
expect -c "
        spawn ssh $ssh_host
	expect Password:
	send \"$EXTRACTED_PASSWORD\r\"
	interact"

