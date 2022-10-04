resource "azurerm_resource_group" "rg" {
    name = "rg-node-api-p01"
}

module "key_vault" {
    source = "[terraform registry?]/key_vault"

    app_name = "node-api"
}

module "sql_server" {
    source = ""
}

module "msi" {
    source = ""
}

module "app_insights" {
    
}