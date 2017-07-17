# Bash utils

A collection of Bash scripts that I've put together over the years

## Listing

* _multi-host-ssh-expect-script_ - If you need to tunnel through a collection of servers, some of which do not support connection through SSH keys but will prompt instead for password. This script uses the [LastPass CLI](https://github.com/LastPass/lastpass-cli).
* _setup_user_ - Streamlines the process of creating a new user on a Linux machine. Specify their username first and optionally an SSH pub key as the second argument.
* _setup_jailed_user_ - Like the previous script but is intended for placing users into a chroot'd jail.
* _transfer_current_nvm_node_modules_ - In case you use [nvm](https://github.com/creationix/nvm) to manage multiple versions of [Node.js](https://nodejs.org) on the same machine, this script helps you to copy over all the global npm modules from your current version into the newest version of node you are installing through nvm.
