#!/bin/bash

su ec2-user -c 'docker pull XXXXXX.dkr.ecr.XXXXXX.amazonaws.com/XXXXXX:latest' 
su ec2-user -c 'docker run -dp 8080:8080 XXXXXX.dkr.ecr.XXXXXX.amazonaws.com/XXXXXX:latest' 