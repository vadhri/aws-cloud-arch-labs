#!/bin/bash

echo 'Cleaning previous state'
rm -rf terraform.tfstate* .terraform*
rm -rf *.pem 

terraform init

./scripts/import_domain.sh
terraform apply
