#!/bin/bash
# Update the package list and install necessary packages
apt update
apt-get install sudo -y

tmux new-session -d -s quil-session bash -c '
#get-ready
wget --no-cache -O - https://raw.githubusercontent.com/lamat1111/quilibriumscripts/master/server_setup.sh | bash

#install node software
wget --no-cache -O - https://raw.githubusercontent.com/lamat1111/QuilibriumScripts/master/qnode_service_installer.sh | bash

#thats all folks
'

