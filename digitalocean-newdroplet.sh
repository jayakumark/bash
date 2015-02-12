#!/bin/bash

# super easy digital ocean droplet provisioner
# requires tugboat to be installed and configured

timestamp=$(date +"%H%M%S")
droplet_name="temp-$timestamp"

tugboat create -i 9801951 -k 585424 $droplet_name
sleep 1
droplet_ip=$(tugboat droplets | grep -i $droplet_name | awk -F "[ ,]" '{print $3}')
echo -e "\n$droplet_ip\n"
