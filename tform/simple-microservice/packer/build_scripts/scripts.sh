#!/bin/sh

sudo yum update -y
sudo amazon-linux-extras install docker
sudo yum install docker -y
sudo yum install amazon-ecr-credential-helper -y

mkdir ~/.docker/
mkdir ~/.aws/

sudo cp /tmp/config.json ~/.docker/config.json
sudo cp /tmp/config.json /etc/docker/config.json
sudo cp /tmp/credentials ~/.aws/credentials
sudo cp /tmp/config ~/.aws/config.json
sudo cp /tmp/rc.local /etc/rc.local
sudo systemctl enable docker.service 

sudo chmod a+x /etc/rc.local
sudo usermod -a -G docker ec2-user
