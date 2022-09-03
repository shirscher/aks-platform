variable "location" {
  type = string
}

variable "environment" {
  type = object({
    name    = string
    postfix = string
  })
}

variable "department" {
  type = object({
    name       = string
    short_name = string
  })
}

variable "vnet_address_space" {
  type = list(string)
}

variable "appgateway_subnet_prefix" {
  type = string
}

variable "apimgmt_subnet_prefix" {
  type = string
}

variable "bastion_subnet_prefix" {
  type = string
}

variable "private_subnet_prefix" {
  type = string
}

variable "aks_node_subnet_prefix" {
  type = string
}

variable "private_link_dns" {
  type = set(string)
  default = [
    "privatelink.azurecr.io",
    "privatelink.blob.core.windows.net",
    "privatelink.documents.azure.com",
    "privatelink.vaultcore.azure.net",
    "privatelink.servicebus.windows.net"
  ]
}