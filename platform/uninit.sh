#!/bin/bash

SERVICE_PRINCIPAL_NAME=sp-terraform-p
RESOURCE_GROUP_NAME=rg-devops-p01

set -e

echo "Removing devops resource group..."
az group delete --name $RESOURCE_GROUP_NAME --yes

echo "Removing service principal..."
SERVICE_PRINCIPAL_ID=$(az ad app list --display-name $SERVICE_PRINCIPAL_NAME | jq -r .[0].id)
az ad app delete --id="$SERVICE_PRINCIPAL_ID"

echo "Removing local terraform files..."
rm ./.terraform.lock.hcl
rm -rf ./.terraform