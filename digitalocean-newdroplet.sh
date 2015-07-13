#!/bin/bash

# super easy digital ocean droplet provisioner
# requires tugboat to be installed and configured

# CLI Arguments
USAGE="Usage: $(basename "$0") DROPLET_IMAGE_ID"
if [ $# == 0 ] ; then
  echo $USAGE
  exit 1;
fi

if [ -n "$1" ] ; then
  DROPLET_IMAGE=$1  
fi

# Hard-coded parameters
DROPLET_NAME_PREFIX="tempdroplet"
DROPLET_REGION=3 # SFO1
DROPLET_SIZE=66 # 512mb
# DROPLET_IMAGE=9801950 # ubuntu-14-04-x64
DROPLET_SSH_KEY=317570 # must be the ssh_key id

timestamp=$(date +"%H%M%S")
droplet_name="$DROPLET_NAME_PREFIX-$timestamp"

tugboat create -i $DROPLET_IMAGE -k $DROPLET_SSH_KEY -s $DROPLET_SIZE -r $DROPLET_REGION $droplet_name
sleep 5
droplet_ip=$(tugboat droplets | grep -i $droplet_name | awk -F "[ ,]" '{print $3}')
echo -e "\n$droplet_ip\n"
