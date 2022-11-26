variable "location" {
    type = string
}

variable "resource_group_name" {
    type = string
}

variable "vnet_address_space" {
    type    = list(string),
    default = ("172.16.0.0/16")
}

variable "dmz_subnet_prefix" {
    type    = string
    default = "172.16.0.0/24"
}

variable "internal_subnet_prefix" {
    type    = string
    default = "172.16.1.0/24"
}

variable "domain_admin_username" {
    type = string
}

variable "domain_admin_password" {
    type      = string
    sensitive = true
}

variable "domain_controller_ip" {
    type = string
    default = "172.16.1.10"
}