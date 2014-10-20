#!/bin/bash

## clear images class
echo -n "" > /var/class/images.class

## loop through real images and create base64 data for images class
for i in $(ls /var/images); do
        echo "\"`echo \"$i\"|tr '[:upper:]' '[:lower:]'`\" := \"`base64 /var/images/$i|tr -d '\n'`\"," >> /var/class/images.class
done