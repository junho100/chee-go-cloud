#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

sudo yum update -y

sudo yum install docker -y

sudo systemctl start docker

sudo usermod -a -G docker $(whoami)

sudo yum install -y ruby

sudo yum install -y wget

cd /home/ec2-user

wget https://aws-codedeploy-ap-northeast-2.s3.ap-northeast-2.amazonaws.com/latest/install

chmod +x ./install

sudo ./install auto