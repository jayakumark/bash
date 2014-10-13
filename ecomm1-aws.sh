#!/bin/sh

# Manually create 'eComm' infrastructure on AWS using the AWS CLI

# VPC

# Subnets
aws ec2 create-subnet --vpc-id vpc-2a894d4f --cidr-block 10.10.1.0/24 --availability-zone eu-west-1a --region eu-west-1
aws ec2 create-subnet --vpc-id vpc-2a894d4f --cidr-block 10.10.2.0/24 --availability-zone eu-west-1b --region eu-west-1
aws ec2 create-subnet --vpc-id vpc-2a894d4f --cidr-block 10.10.3.0/24 --availability-zone eu-west-1c --region eu-west-1
aws ec2 create-subnet --vpc-id vpc-2a894d4f --cidr-block 10.10.4.0/24 --availability-zone eu-west-1a --region eu-west-1
aws ec2 create-subnet --vpc-id vpc-2a894d4f --cidr-block 10.10.5.0/24 --availability-zone eu-west-1a --region eu-west-1