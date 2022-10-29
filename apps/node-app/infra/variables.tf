variable "location" {
  type = string
}

variable "app_name" {
  type = string
}
variable "environment_postfix" {
  type = string
}

variable "admin_username" {
  type      = string
  sensitive = true
}
variable "admin_password" {
  type      = string
  sensitive = true
}

locals {
  resource_group_name   = format("rg-%s-%s", var.app_name, var.environment_postfix)
  sql_server_name       = format("sqlsvr-%s-%s", var.app_name, var.environment_postfix)
  database_name         = format("sqldb-%s-%s", var.app_name, var.environment_postfix)
  managed_identity_name = format("mi-%s-%s", var.app_name, var.environment_postfix)
}