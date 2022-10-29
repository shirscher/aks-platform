variable "resource_group_name" {
    type = string
}

variable "location" {
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

variable "sql_server_name" {
    type = string
}
variable "database_name" {
    type = string
}