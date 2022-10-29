resource "azurerm_user_assigned_identity" "mid" {
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
}