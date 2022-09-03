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