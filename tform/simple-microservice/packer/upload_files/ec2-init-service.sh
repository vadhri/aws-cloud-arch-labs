#!/bin/bash

su ec2-user -c 'docker pull 166517699715.dkr.ecr.us-east-1.amazonaws.com/services:latest' 
su ec2-user -c 'docker run -dp 8080:8080 166517699715.dkr.ecr.us-east-1.amazonaws.com/services:latest' 