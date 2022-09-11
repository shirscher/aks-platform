terraform {
  /* Uncomment this block to use Terraform Cloud for this tutorial
  cloud {
    organization = "organization-name"
    workspaces {
      name = "learn-terraform-module-use"
    }
  }
  */

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm",
      version = "~> 3.21.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.1.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
  }

  required_version = ">= 1.2.0"

  backend "azurerm" {
    resource_group_name  = "rg-devops-p01" # Must match in setup/sorage-account-deploy.bicep
    storage_account_name = "sadevopsp01"   # Must match in setup/sorage-account-deploy.bicep
    container_name       = "terraform"     # Must match in setup/sorage-account-deploy.bicep
    key                  = "prod.terraform.tfstate"
    use_azuread_auth     = true
    # MSI auth not working in WSL
    #use_msi              = true
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "kubectl" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}