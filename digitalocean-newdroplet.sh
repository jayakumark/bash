#!/bin/bash

# super easy digital ocean droplet provisioner
# requires tugboat to be installed and configured

# Parameters - edit these
DROPLET_NAME_PREFIX="tempdroplet"
DROPLET_REGION=3 # SFO1
DROPLET_SIZE=66 # 512mb
DROPLET_IMAGE=9801950 # ubuntu-14-04-x64
DROPLET_SSH_KEY=317570 # must be the ssh_key id

timestamp=$(date +"%H%M%S")
droplet_name="$DROPLET_NAME_PREFIX-$timestamp"

tugboat create -i $DROPLET_IMAGE -k $DROPLET_SSH_KEY -s $DROPLET_SIZE -r $DROPLET_REGION $droplet_name
sleep 5
droplet_ip=$(tugboat droplets | grep -i $droplet_name | awk -F "[ ,]" '{print $3}')
echo -e "\n$droplet_ip\n"
