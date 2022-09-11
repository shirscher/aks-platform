#!/bin/bash

STORAGE_BLOB_DATA_OWNER_ID=$(az role definition list -n 'Storage Blob Data Owner' -o tsv --query [].id)
STORAGE_BLOB_DATA_CONTRIB_ID=$(az role definition list -n 'Storage Blob Data Contributor' -o tsv --query [].id)
OWNER_USER_ID=$(az ad signed-in-user show -o tsv --query id)
#CONTRIB_USER_ID=()
SERVICE_PRINCIPAL_NAME=sp-terraform-p
RESOURCE_GROUP_NAME=rg-devops-p01

echo "Create storage account for Terraform state"
az deployment sub create -f ./init/storage-account-deploy.bicep -l eastus2 \
    --parameters storageBlobDataOwnerRoleId=$STORAGE_BLOB_DATA_OWNER_ID \
                 storageBlobDataContribRoleId=$STORAGE_BLOB_DATA_CONTRIB_ID \
                 ownerUserId=$OWNER_USER_ID \
                 contribUserId=$CONTRIB_USER_ID
                #resourceGroupName=$RESOURCE_GROUP_NAME # TODO: Add as parameter

echo "Create a service principal for applying changes"
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
JSON=$(az ad sp create-for-rbac --name="$SERVICE_PRINCIPAL_NAME" --role="Contributor" --scopes="/subscriptions/$ARM_SUBSCRIPTION_ID")
export ARM_SP_CLIENT_ID=$(echo $JSON | jq .appId)
export ARM_SP_CLIENT_SECRET=$(echo $JSON | jq .password)
export ARM_TENANT_ID=$(echo $JSON | jq .tenant)

unset KUBE_CONFIG_FILE
unset KUBE_CONFIG_FILES

terraform init