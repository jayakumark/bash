#!/bin/bash

# super easy aws ec2 instance provisioner
# requires AWS CLI to be installed and configured

# Parameters - edit these
INSTANCE_NAME_PREFIX="tempinstance"
INSTANCE_REGION='us-west-2'
INSTANCE_TYPE='t2.micro'
INSTANCE_AMI_ID='ami-29ebb519' # ubuntu-14-04-x64
INSTANCE_COUNT=1
EC2_KEY='adamkeys' # aws ec2 describe-key-pairs


timestamp=$(date +"%H%M%S")
instance_tag_name="temp-$timestamp"

instance_id=$(aws ec2 run-instances \
              --image-id $INSTANCE_AMI_ID \
              --instance-type $INSTANCE_TYPE \
              --key-name $EC2_KEY \
              --count $INSTANCE_COUNT \
              | grep -i instanceid | awk -F "\"" '{print $4}')
#instance_id=$(echo $response | grep -i instanceid | awk -F "\"" '{print $4}')
echo "New instance, $instance_id, launched in $INSTANCE_REGION.  Getting IP..."

sleep 5
instance_ip=$(aws ec2 describe-instances --instance-ids $instance_id | grep -i "PublicIpAddress" | awk -F "\"" '{print $4}')
echo -e "\n$instance_ip"
echo -e "\n To destroy:  aws ec2 terminate-instances --instance-ids $instance_id\n"
