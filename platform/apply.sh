#!/bin/bash

set -e

echo "Checking login status of az command line..."
az account show &>/dev/null
if [[ "$?" != 0 ]]
then
  if [ -z "$PS1" ]; then
    die "You must log into Azure with the 'az login' command"
  else
    az login
  fi
else
  echo "Logged into Azure"

  echo "Checking for Microsoft.ContainerService/EnableWorkloadIdentityPreview feature..."
  extension=$(az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/EnableWorkloadIdentityPreview') && @.properties.state == 'Registered'].{Name:name}" --output tsv)
  if [[ -z $extension ]]; then
    echo "Registering Microsoft.ContainerService/EnableWorkloadIdentityPreview feature"
    az feature register --name EnableWorkloadIdentityPreview --namespace Microsoft.ContainerService
    # TODO: Technically should wait for registration to complete. See https://github.com/Azure-Samples/azure-ad-workload-identity-mi/blob/36b7bc3aa39285e4feaba69a5b7d3fc10639a6f1/scripts/04-enable-workload-identity.sh
    echo "Refreshing the registration of the Microsoft.ContainerService resource provider..."
    az provider register --namespace Microsoft.ContainerService
  fi

  echo "Applying terraform config..."
  terraform apply -var-file="./prod.tfvars" -auto-approve
fi

