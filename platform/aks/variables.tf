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

variable "log_analytics_workspace_id" {
  type = string
}

variable "nodepool_subnet_id" {
  type = string
}

variable "pod_cidr" {
  type = string
}

variable "service_cidr" {
  type = string
}

variable "dns_service_ip" {
  type = string
}

variable "docker_bridge_cidr" {
  type = string
}
