#
# Data
#

data "azurerm_subscription" "current" {}

#
# Resources
#

# Cost alert on subscription

resource "azurerm_consumption_budget_subscription" "subscription_budget" {
  name            = "dev-budget"
  subscription_id = data.azurerm_subscription.current.id

  amount     = 20
  time_grain = "Monthly"

  time_period {
    start_date = formatdate("YYYY-MM-01'T00:00:00Z'", timestamp())
    end_date   = "2030-01-01T00:00:00Z"
  }

  notification {
    enabled   = true
    threshold = 50 # % of budget
    operator  = "GreaterThanOrEqualTo"

    contact_emails = [
      "shirscher@gmail.com",
    ]

    contact_roles = [
      "Owner",
    ]
  }
}

# TODO: Create budget alert group to kick off runbook that deletes all resources except rg-devops-p01 (terraform state) and rg-budget-p01 (the runbook itself)
