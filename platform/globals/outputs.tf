output "locations" {
    value =
        {
            eastus = {
                name = "eastus"
                description = "East US"
                short_name = "eus"
            }
            eastus2 = {
                name = "eastus2"
                description = "East US 2"
                short_name = "eus2"
            }
            westus = {
                name = "westus"
                description = "West US"
                short_name = "wus"
            }
            westus2 = {
                name = "westus2"
                description = "West US 2"
                short_name = "wus2"
            }
            westus3 = {
                name = "westus3"
                description = "West US 3"
                short_name = "wus3"
            }
        }
}

output "environments" {
    value =
        {
            production = {
                name = "production"
                description = "Production"
                short_name = "p"
            }
            non_production = {
                name = "nonproduction"
                description = "Non-Production"
                short_name = "np"
            }
            qa = {
                name = "qa"
                description = "QA"
                short_name = "q"
            }
            development = {
                name = "development"
                description = "Development"
                short_name = "d"
            }
            sandbox = {
                name = "sandbox"
                description = "Sandbox"
                short_name = "s"
            }
        }
}