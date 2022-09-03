// Deploys a storage account and container for managing Terraform state
targetScope = 'subscription'

param resourceGroupName string = 'rg-devops-p01' // Must match in terraform.tf
param location string = deployment().location
param storageAccountName string = 'sadevopsp01' // Must match in terraform.tf
param storageBlobDataOwnerRoleId string
param storageBlobDataContribRoleId string
param ownerUserId string
param contribUserId string

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: resourceGroupName
  location: location
}

module storageaccount 'storage-account.bicep' = {
  name: deployment().name
  scope: rg
  params: {
    storageBlobDataOwnerRoleId: storageBlobDataOwnerRoleId
    storageBlobDataContribRoleId: storageBlobDataContribRoleId
    ownerUserId: ownerUserId
    contribUserId: contribUserId
    location: location
    storageAccountName: storageAccountName
  }
}
