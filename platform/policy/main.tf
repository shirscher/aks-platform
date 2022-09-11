#
# Data
#

data "azurerm_subscription" "current" {}

#
# Resources
#

resource "azurerm_subscription_policy_assignment" "require_rg_environment_tag" {
  name                 = "require-rg-environment-tag"
  subscription_id      = data.azurerm_subscription.current.id
  location             = var.location
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025"
  display_name         = "Require the 'Environment' tag on resource groups."
  description          = "Enforces existence of the 'Environment' tag on resource groups."
  enforce              = false # Not enforcing for now due to AKS creating it's own node pool resource group
  parameters           = <<PARAMETERS
                          {
                            "tagName": {
                              "value": "Environment"
                            }
                          }
                         PARAMETERS
}

resource "azurerm_subscription_policy_assignment" "inherit_rg_environment_tag" {
  name                 = "inherit-rg-environment-tag"
  subscription_id      = data.azurerm_subscription.current.id
  location             = var.location
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/cd3aa116-8754-49c9-a813-ad46512ece54"
  description          = "Adds or replaces the 'Environment' tag and value from the parent resource group when any resource is created or updated. Existing resources can be remediated by triggering a remediation task."
  display_name         = "Inherit the 'Environment' tag from the resource group"
  identity {
    type = "SystemAssigned"
  }
  parameters = <<PARAMETERS
                          {
                            "tagName": {
                              "value": "Environment"
                            }
                          }
                         PARAMETERS
}