#
# VNet
#
resource "azurerm_resource_group" "rg" {
  name     = format("rg-%s-network-%s01", var.department.short_name, var.environment.postfix)
  location = var.location
  tags = {
    Environment = var.environment.name
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = format("vnet-%s-%s01", var.department.short_name, var.environment.postfix)
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    Environment = var.environment.name
  }
}

resource "azurerm_network_watcher" "network_watcher" {
  name                = format("netwatcher-%s-%s01", var.department.short_name, var.environment.postfix)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    Environment = var.environment.name
  }
}

#
# Subnets
#
resource "azurerm_subnet" "app_gateway_subnet" {
  name                 = "AppGatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.app_gateway_subnet_prefix]
}

resource "azurerm_subnet" "private_subnet" {
  name                 = "PrivateSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.private_subnet_prefix]
}

resource "azurerm_subnet" "aks_node_subnet" {
  name                 = "AksNodePoolSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.aks_node_subnet_prefix]
}

resource "azurerm_subnet" "api_mgmt_subnet" {
  name                 = "ApiManagementSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.apimgmt_subnet_prefix]
  delegation {
    name = "apimgmt_delegation"
    service_delegation {
      name = "Microsoft.ApiManagement/service"
    }
  }
}


#
# Bastion + Jump Box
#
# resource "azurerm_resource_group" "bastion_rg" {
#   name     = format("rg-%s-jumpbox-%s01", var.department.short_name, var.environment.postfix)
#   location = var.location
#   tags = {
#     Environment = var.environment.name
#     Team        = "Platform"
#   }
# }

# resource "azurerm_subnet" "bastion_subnet" {
#   name                 = "AzureBastionSubnet" # Subnet name MUST be this
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = [var.bastion_subnet_prefix]
# }

# resource "azurerm_public_ip" "ip" {
#   name                = format("pip-%s-bastion-%s01", var.department.short_name, var.environment.postfix)
#   location            = azurerm_resource_group.bastion_rg.location
#   resource_group_name = azurerm_resource_group.bastion_rg.name
#   allocation_method   = "Static"
#   sku                 = "Standard"

#   tags = {
#     Environment = var.environment.name
#   }
# }

# resource "azurerm_bastion_host" "bastion" {
#   name                = format("bastion-%s-%s01", var.department.short_name, var.environment.postfix)
#   location            = azurerm_resource_group.bastion_rg.location
#   resource_group_name = azurerm_resource_group.bastion_rg.name

#   ip_configuration {
#     name                 = "configuration"
#     subnet_id            = azurerm_subnet.bastion_subnet.id
#     public_ip_address_id = azurerm_public_ip.ip.id
#   }

#   tags = {
#     Environment = var.environment.name
#   }
# }

# TODO: Jumpbox VM
# Using AAD credentials? https://docs.microsoft.com/en-us/azure/active-directory/devices/howto-vm-sign-in-azure-ad-linux

#
# Private Endpoint DNS
#

# resource "azurerm_private_dns_zone" "private_dns_zones" {
#   for_each            = var.private_link_dns
#   name                = each.key
#   resource_group_name = azurerm_resource_group.rg.name
#   tags = {
#     Environment = var.environment.name
#   }
# }