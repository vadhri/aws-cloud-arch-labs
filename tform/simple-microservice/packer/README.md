The files in this folder enable a packer build for an image that contains docker configured to pull from ecr registry. In order to use the right values for configuration, configure the files upload_files folder. The contents are described below. 

An IAM user should be configured that has permissions for the ecr registries. 

|file | description|
| --- | --- |
|aws_config |  region configuration (aws config file that will be copied into ~/.aws/config location of the image)|
|aws_cred | AWS access id and secret (aws credentails file that will be copied to ~/.aws/credentials)|
|ec2-init-service(dot)sh | This file will eventually become the script that runs everytime that the ec2 instance starts.|

# Pre requisites
The packer build command will try to use admin cred in aws account that is configured in the ~/.aws/credtials of the local machine. 
The account + region should have a public subnet (or default subnet) that has access to internet gateway. The subnet details should be included in the ec2.tf script.

# Build command
```
packer build image.pkr.hcl

The outcome of the build will be an AMI printed in the console, grab it for usage in ec2.tf script in infra folder. 