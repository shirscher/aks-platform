#!/bin/sh

set -e

echo "Checking login status of az command line..."
az account show &>/dev/null
if [[ "$?" != 0 ]]
then
  if [ -z "$PS1" ]; then
    # Non-interactive shell
    die "You must log into Azure with the 'az login' command"
  else
    echo "running az login..."
    az login
  fi
fi

echo "Running terraform destroy for platform..."
terraform destroy -input=false -var-file="./prod.tfvars" -input=false -auto-approve
