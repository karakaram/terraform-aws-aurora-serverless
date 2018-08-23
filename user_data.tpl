#!/bin/bash

# Update all packages
yum -y update

# Install CloudWatch Agent
cd /tmp
wget https://s3.amazonaws.com/amazoncloudwatch-agent/linux/amd64/latest/AmazonCloudWatchAgent.zip
unzip AmazonCloudWatchAgent.zip
./install.sh

# Start CloudWatch Agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:AmazonCloudWatch-Agent-${name} -s

# Mount an additional EBS
if [ "$(file -s /dev/xvdf)" == "/dev/xvdf: data" ]; then
    mkfs -t xfs /dev/xvdf
fi
mkdir -p /mnt/ebs1
mount /dev/xvdf /mnt/ebs1
chown ec2-user. /mnt/ebs1
echo "/dev/xvdf   /mnt/ebs1   xfs     defaults,nofail        0   2" >>/etc/fstab

## Reboot on kernel update
grubby --default-kernel | grep `uname -r` || reboot
