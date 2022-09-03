# Platform Modules

## DevOps

The shared resources needed to perform deployments to a subscription.

- Azure Container Registry
- Azure Storage Account
    - Used to store Terraform state, shared ARM templates, and any other artifacts required for deployments and CI/CD tools.
- Azure Key Vault (need this?)
    - Used to 
    - This should not be used to store application level

## Core

Creates the core networking, logging, and other resources shared by other components.

- Log Analytics Workspace
- ?

## Higher Level Components

### AKS Cluster

### App Service

### Function App

## Lower Level Components

### App Gateway

### Database

### Key Vault

