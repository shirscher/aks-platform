param location string = resourceGroup().location
param storageAccountName string
param storageBlobDataOwnerRoleId string
param storageBlobDataContribRoleId string
param ownerUserId string
param contribUserId string

resource sa 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  tags: {
    Environment: 'Production'
  }
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    largeFileSharesState: 'Enabled'
    networkAcls: {
      resourceAccessRules: []
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  name: '${sa.name}/default/terraform'
  properties: {}
}

resource ownerRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: sa
  name: guid(sa.id, ownerUserId, storageBlobDataOwnerRoleId)
  properties: {
    roleDefinitionId: storageBlobDataOwnerRoleId
    principalId: ownerUserId
    principalType: 'User'
  }
}

resource contribRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = if(contribUserId != '' && contribUserId != null) {
  scope: container
  name: guid(sa.id, contribUserId, storageBlobDataContribRoleId)
  properties: {
    roleDefinitionId: storageBlobDataContribRoleId
    principalId: contribUserId
    principalType: 'User'
  }
}
