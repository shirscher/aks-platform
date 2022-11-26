# Platform Modules

# Scopes

## /core

The core cloud components. There is only one instance of these components that are shared by all environments. These components will live in their own subscription.

Components:
- Hub network
    - Hub VNet
    - VPN / ExpressRoute / VWAN
- Identity & access management
- Policies
- Centralized logging
- Platform applications
    - Self service landing zone creation - A web app where users can request new landing zones
    - Self service IAM - A web app and API where users can request new user accounts or changes to group memberships
    - Sandbox cleaner - Keeps track of all Sandbox tier landing zones and deletes resources in the them on a regular schedule.
        - Could this be a policy?

Owned by Platform teams

## /landing-zone

Provides the base resources needed for landing zone. A landing zone corresponds one-to-one with a subscription. Landing zones will be created in Production and Non-Production pairs, where Production contains one production environment, and Non-Production may contain many lower level environments such as "Development", "QA", "Test", etc.

Inputs
- Name - Defines the scope of the landing zone. e.g. a department or a large system.
- Tier - "Production", "Non-Production", or "Sandbox". Sandbox landing zones have looser restrictions but
- Cost Center

Components
- Spoke V-Net <- or does this go in an environment?
    - Includes peering to hub (optional)
- Kubernetes cluster <- or does this go in an environment?
- Container registry? Key Vault?
- Identity & access management

## /environment



Examples:
- Production (P)
- Development (D)


Abbreviations used in names:
- P = Production
- T = Test
- Q = QA
- D = Development
- S = Sandbox


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

