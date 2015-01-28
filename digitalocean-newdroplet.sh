#!/bin/bash

# A quick script to fire up a droplet (VM) on DigitalOcean public cloudz
# requires:  bash, curl, jq

# Parameters - edit these
TOKENPATH="/Users/adpatter/.ssh/digitalocean-work"
DROPLET_NAME_PREFIX="tempdroplet"
DROPLET_REGION="sfo1"
DROPLET_SIZE="512mb"
DROPLET_IMAGE="ubuntu-14-04-x64" # must be slug -string-, not numerical ID - https://api.digitalocean.com/v2/images?type=distribution
DROPLET_SSH_KEY="585424" # must be the ssh_key id or fingerprint - https://api.digitalocean.com/v2/account/keys
API_ENDPOINT="https://api.digitalocean.com/v2/droplets"
SSH_KEY_PATH="/path/to/sshkey" # optional, set this to print out a convenient ssh cmd line to connect afterwards

### Code

# Funtions
timestamp() {
  date +"%Y%m%d%H%M%S"
}

# Setup constants
TOKEN=$(cat $TOKENPATH) # TOKEN string for OAuth 1.0 authentication
DROPLET_NAME="$DROPLET_NAME_PREFIX-$(timestamp)"

# JSON string built from variables above - only double quotes need to be escaped
JSON="{\"name\":\"$DROPLET_NAME\",\"region\":\"$DROPLET_REGION\",\"size\":\"$DROPLET_SIZE\",\"image\":\"$DROPLET_IMAGE\",\"ssh_keys\":[\"$DROPLET_SSH_KEY\"]}"

echo "Creating a droplet via $API_ENDPOINT"

echo $JSON | jq .

new_droplet=$(curl -qSs -X POST "$API_ENDPOINT" -d$JSON -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json")

droplet_id=$(echo $new_droplet | jq '.droplet | .id')

sleep 3 # added this delay since sometimes the create response returns without the IP address

droplet_status_json=$(curl -qSs -X GET "$API_ENDPOINT/$droplet_id" -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json")

new_droplet_ip_string=$(echo $droplet_status_json | jq '.droplet | .networks | .v4 | .[] | .ip_address')
new_droplet_ip=$(echo $new_droplet_ip_string | sed 's/.\(.*\)/\1/' | sed 's/\(.*\)./\1/')

echo -e "\nNew droplet created - NAME:$DROPLET_NAME - ID:$droplet_id - IP:$new_droplet_ip"
echo -e "\n \t ssh -i $SSH_KEY_PATH root@$new_droplet_ip \n"
