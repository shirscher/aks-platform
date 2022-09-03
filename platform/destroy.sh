#!/bin/sh

SERVICE_PRINCIPAL_NAME=sp-terraform-p

echo "Running terraform destroy..."
terraform destroy -var-file="./prod.tfvars" -auto-approve
echo "Removing devops resource group..."
az group delete --name 'rg-devops-p01' --yes
echo "Removing service principal..."
SERVICE_PRINCIPAL_ID=$(az ad app list --display-name $SERVICE_PRINCIPAL_NAME | jq -r .[0].id)
az ad app delete --id="$SERVICE_PRINCIPAL_ID"