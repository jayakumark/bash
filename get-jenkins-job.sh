#!/bin/bash

# Get a config.xml for a given jenkins job.  Must have username/password.
# Usage:
#   bash get-job.sh -s [JENKINS_HOSTNAME] -j [JOB_NAME] -u [USERNAME]

### Parameters
outfile='config.xml'

### Script
usage_message=" Usage: bash get-job.sh -s [JENKINS_HOSTNAME] -j [JOB_NAME] -u [USERNAME]"

if (($# == 0)); then
  echo "Missing opts."
  echo "$usage_message"
  exit 1
fi

while getopts ":s:j:u:" opt; do
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

if [ -f ./$outfile ]; then
  outfile="$outfile-$(date +%H%M%S)"
fi

curl -k -X GET "https://$jenkins_server/job/$job_name/config.xml" \
  -u $username \
  -o $outfile

echo "Got job, $job_name, and outputted to $outfile."
echo "Done."
