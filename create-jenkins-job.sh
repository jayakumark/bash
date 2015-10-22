#!/bin/bash

# Supplied with a config.xml, create new Jenkins job on remote server.
# Must have username/password.

# Usage:
#   bash put-job.sh -s [JENKINS_HOSTNAME] -j [JOB_NAME] -u [USERNAME] -c [CONFIG.XML] [-f]

### Parameters

### Script
usage_message=" Usage: bash put-job.sh -s [JENKINS_HOSTNAME] -j [JOB_NAME] -u [USERNAME] -c [CONFIG.XML] [-f]"

if (($# == 0)); then
  echo "Missing opts."
  echo "$usage_message"
  exit 1
fi

while getopts ":s:j:u:c:" opt; do
  case $opt in
    s)
      jenkins_server="$OPTARG"
      ;;
    j)
      job_name="$OPTARG"
      ;;
    u)
      username="$OPTARG"
      ;;
    c)
      config_file="$OPTARG"
      ;;
    f)
      force=true
      ;;
    \?)
      echo "Bad argument."
      echo "$usage_message"
      exit 1
      ;;
    :)
      echo "The -$OPTARG requires argument."
      exit 1
      ;;
  esac
done

if [ ! -f $config_file ]; then
  echo "Can't find $config_file.  Please fix."
  exit 1
fi

read -s -p "Please enter your password: " password
echo ""
echo "Checking if job already exists..."

# see if job already exists
resp=$(curl -s -k -X GET "https://$jenkins_server/checkJobName?value=$job_name" \
  -u $username:$password) 2>&1>/dev/null
if [[ $resp == *"already exists"* ]]; then
  echo "The job named, $job_name, already exists. Try a different name..."
  exit 1
fi

echo -n "Job does not exist yet.  Creating..."

# upload job
curl -s -k -X POST "https://$jenkins_server/createItem?name=$job_name" \
  --data-binary @$config_file \
  -H "Content-Type:text/xml" \
  -u $username:$password 2>&1>/dev/null

echo "Success"
echo "$job_name created."
echo "Done."
