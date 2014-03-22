#!/bin/bash

# Copyright © 2011-2012 VMware, Inc. All rights reserved.
# This script is used to increase staging storage size on the vCCNode by adding additional disks. 

if [ $# -lt 1 ]; then
echo Usage: 
echo '>./add_disk.sh device-name, where device-name is a disk device in /dev such as sdc'
exit 1
fi

function echo {
    /bin/echo $*
    /bin/echo "[$(date)] $*" >> /opt/vmware/hcagent/logs/add_disk.log 
}

exec 2>> /opt/vmware/hcagent/logs/add_disk.log 

DEVICE=/dev/$1
LVG=data_vg
LV=/dev/$LVG/data

echo "Adding disk $DEVICE to logical volume $LV ..."

pvcreate $DEVICE && vgextend $LVG $DEVICE && lvextend -l +100%FREE $LV && resize2fs $LV

if [ $? -eq 0 ]; then
  echo "Adding disk completed."
fi
