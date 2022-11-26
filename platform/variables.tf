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

variable "instance_number" {
  type = number
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "app_gateway_subnet_prefix" {
  type = string
  validation {
    condition     = can(cidrnetmask(var.app_gateway_subnet_prefix))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "apimgmt_subnet_prefix" {
  type = string
  validation {
    condition     = can(cidrnetmask(var.apimgmt_subnet_prefix))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "bastion_subnet_prefix" {
  type = string
  validation {
    condition     = can(cidrnetmask(var.bastion_subnet_prefix))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "private_subnet_prefix" {
  type = string
  validation {
    condition     = can(cidrnetmask(var.private_subnet_prefix))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "aks_node_subnet_prefix" {
  type = string
  validation {
    condition     = can(cidrnetmask(var.aks_node_subnet_prefix))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "pod_cidr" {
  type        = string
  description = "Specifies the CIDR notation IP range from which to assign pod IPs when kubenet is used."
  validation {
    condition     = can(cidrnetmask(var.pod_cidr))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "service_cidr" {
  type        = string
  description = "A CIDR notation IP range from which to assign service cluster IPs. It must not overlap with any Subnet IP ranges."
  validation {
    condition     = can(cidrnetmask(var.service_cidr))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "dns_service_ip" {
  type        = string
  description = "Specifies the IP address assigned to the Kubernetes DNS service. It must be within the Kubernetes service address range specified in service_cidr."
}

variable "docker_bridge_cidr" {
  type        = string
  description = "Specifies the CIDR notation IP range assigned to the Docker bridge network. It must not overlap with any Subnet IP ranges or the Kubernetes service address range."
  validation {
    condition     = can(cidrnetmask(var.docker_bridge_cidr))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

#
# Locals
#

locals {
  aks_resource_group_name      = format("rg-%s-aks-%s%02s", var.department.short_name, var.environment.postfix, var.instance_number)
  aks_name                     = format("aks-%s-%s%02s", var.department.short_name, var.environment.postfix, var.instance_number)
  aks_node_resource_group_name = format("rg-%s-aks-%s%02s-nodes", var.department.short_name, var.environment.postfix, var.instance_number)
  app_gateway_name             = format("appgw-%s-%s%02s", var.department.short_name, var.environment.postfix, var.instance_number)
}
