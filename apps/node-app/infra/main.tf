resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
}

#module "key_vault" {
#  key_vault_name = local.key_vault_name
#}

module "sql_database" {
  source = "./sql-database"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sql_server_name     = local.sql_server_name
  database_name       = local.database_name
  admin_username      = var.admin_username
  admin_password      = var.admin_password
}

module "managed_identity" {
  source = "./managed-identity"

  name                = local.managed_identity_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

#module "static_web_storage" {
#  source = "./static-web-storage"  
#}

#module "key_vault" {
#  source = "./key-vault"
#}

#module "app_insights" {
#  source = "./app-insights"
#}