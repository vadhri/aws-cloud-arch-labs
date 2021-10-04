#!/bin/bash

su ec2-user -c 'docker pull XXXXXXX.dkr.ecr.us-east-1.amazonaws.com/XXXXXXX:latest' 
su ec2-user -c 'docker run -dp 8080:8080 XXXXXXX.dkr.ecr.us-east-1.amazonaws.com/XXXXXXX:latest' 