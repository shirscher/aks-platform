#
# Variables
#

variable "location" {
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
  type    = list(string)
  default = ["10.0.0.0/16"]
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

variable "pod_cidr" {
  type        = string
  description = "Specifies the CIDR notation IP range from which to assign pod IPs when kubenet is used."
}

variable "service_cidr" {
  type        = string
  description = "A CIDR notation IP range from which to assign service cluster IPs. It must not overlap with any Subnet IP ranges."
}

variable "dns_service_ip" {
  type        = string
  description = "Specifies the IP address assigned to the Kubernetes DNS service. It must be within the Kubernetes service address range specified in service_cidr."
}

variable "docker_bridge_cidr" {
  type        = string
  description = "Specifies the CIDR notation IP range assigned to the Docker bridge network. It must not overlap with any Subnet IP ranges or the Kubernetes service address range."
}

#
# Locals
#

locals {
  aks_resource_group_name      = format("rg-%s-aks-%s01", var.department.short_name, var.environment.postfix)
  aks_name                     = format("aks-%s-%s01", var.department.short_name, var.environment.postfix)
  aks_node_resource_group_name = format("rg-%s-aks-%s01-nodes", var.department.short_name, var.environment.postfix)
}
