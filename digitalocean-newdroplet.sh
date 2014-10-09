#!/bin/bash

# Parameters
TOKEN=$(cat ~/.ssh/.digitaloceantoken)
API_ENDPOINT="https://api.digitalocean.com/v2/droplets"

JSON='{"name":"tempdroplet","region":"sfo1","size":"512mb","image":6375382}'

echo $JSON

# Code
echo "Creating a droplet on digitalocean..."
curl -X POST "$API_ENDPOINT" \
	-d$JSON \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/json"
