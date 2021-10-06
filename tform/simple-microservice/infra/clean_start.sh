#!/bin/bash

echo 'Cleaning previous state'

read -p "Are you sure? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    cp terraform.tfstate.state terraform.tfstate.old

    rm -rf terraform.tfstate* .terraform*
    rm -rf *.pem 

    terraform init

    ./scripts/import_domain.sh
    terraform apply
fi


