terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm",
      version = "~> 3.28.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.1.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.1.0"
    }
  }

  required_version = ">= 1.2.0"

  backend "azurerm" {
    resource_group_name  = "rg-devops-p01" # Must match in setup/sorage-account-deploy.bicep
    storage_account_name = "sadevopsp01"   # Must match in setup/sorage-account-deploy.bicep
    container_name       = "terraform"     # Must match in setup/sorage-account-deploy.bicep
    key                  = "prod.terraform.tfstate"
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# data "terraform_remote_state" "aks_remote" {
#   backend = "azurerm"
#   config = {
#     resource_group_name  = "rg-devops-p01" # Must match in setup/sorage-account-deploy.bicep
#     storage_account_name = "sadevopsp01"   # Must match in setup/sorage-account-deploy.bicep
#     container_name       = "terraform"     # Must match in setup/sorage-account-deploy.bicep
#     key                  = "prod.platform.tfstate"
#     use_azuread_auth     = true
#   }
# }

provider "helm" {
  kubernetes {
    host                   = module.aks.host
    username               = module.aks.username
    password               = module.aks.password
    client_certificate     = module.aks.client_certificate
    client_key             = module.aks.client_key
    cluster_ca_certificate = module.aks.cluster_ca_certificate
  }
}

provider "kubernetes" {
  host                   = module.aks.host
  username               = module.aks.username
  password               = module.aks.password
  client_certificate     = module.aks.client_certificate
  client_key             = module.aks.client_key
  cluster_ca_certificate = module.aks.cluster_ca_certificate
}

provider "kubectl" {
  host                   = module.aks.host
  username               = module.aks.username
  password               = module.aks.password
  client_certificate     = module.aks.client_certificate
  client_key             = module.aks.client_key
  cluster_ca_certificate = module.aks.cluster_ca_certificate
  load_config_file       = "false" # Required to avoid this issue: https://github.com/gavinbunney/terraform-provider-kubectl/issues/35
}

provider "http" {
}