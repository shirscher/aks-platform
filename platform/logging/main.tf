resource "azurerm_resource_group" "rg" {
  name     = format("rg-%s-logging-%s01", var.department.short_name, var.environment.postfix)
  location = var.location
  tags = {
    Environment = var.environment.name
  }
}

resource "azurerm_log_analytics_workspace" "workspace" {
  name                = format("logws-%s-%s01", var.department.short_name, var.environment.postfix)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
}

resource "azurerm_log_analytics_solution" "solution" {
  solution_name         = "ContainerInsights"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.workspace.id
  workspace_name        = azurerm_log_analytics_workspace.workspace.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}