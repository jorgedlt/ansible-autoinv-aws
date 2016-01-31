#!/usr/bin/env bash

# Create Assible inventory file from AWS Environment

INVfile=aws.inventory
SSHkey='ansible_ssh_private_key_file=/home/ubuntu/.aws/m3DEVaws.pem'
SSHuid='ansible_ssh_user=ubuntu'

MASTER=$(aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,PrivateIpAddress]' \
   --filter "Name=tag:Name,Values=AWSCLI v1.2 master" --output text | tr '\t' ' ')

WORKERS=$(aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,PrivateIpAddress]' --filter "Name=tag:Project,V
alues=HP-DEMO" "Name=instance-state-name,Values=running" --output text | tr '\t' ' ')

echo '[Master]' > $INVfile
 while IFS=' ' read instanceID PrivIpAddr; do
     echo "${instanceID} ansible_host=${PrivIpAddr} ${SSHkey} ${SSHuid}"
 done <<< "$MASTER" >> $INVfile ; echo >> $INVfile

echo '[Workers]' >> $INVfile
 while IFS=' ' read instanceID PrivIpAddr; do
    echo "${instanceID} ansible_host=${PrivIpAddr} ${SSHkey} ${SSHuid}"
 done <<< "$WORKERS" >> $INVfile

cat $INVfile | ccze -A

exit 0;

# Sample Out

# [Master]
# i-5ef5eae8 ansible_host=172.31.46.139 ansible_ssh_private_key_file=/home/ubuntu/.aws/m3DEVaws.pem ansible_ssh_user=ubuntu
#
# [Workers]
# i-4b317ec2 ansible_host=172.31.42.237 ansible_ssh_private_key_file=/home/ubuntu/.aws/m3DEVaws.pem ansible_ssh_user=ubuntu
# i-45317ecc ansible_host=172.31.41.151 ansible_ssh_private_key_file=/home/ubuntu/.aws/m3DEVaws.pem ansible_ssh_user=ubuntu
# i-05307f8c ansible_host=172.31.43.246 ansible_ssh_private_key_file=/home/ubuntu/.aws/m3DEVaws.pem ansible_ssh_user=ubuntu
#
