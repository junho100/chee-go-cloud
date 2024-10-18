#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

sudo yum update -y

sudo yum install docker -y

sudo systemctl start docker

sudo usermod -a -G docker $(whoami)