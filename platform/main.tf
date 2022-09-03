module "budgeting" {
  source = "./budgeting"
}

module "policy" {
  source = "./policy"

  location    = var.location
  environment = var.environment
  department  = var.department
}

module "logging" {
  source = "./logging"

  location    = var.location
  environment = var.environment
  department  = var.department
}

module "vnet" {
  source = "./vnet"

  location    = var.location
  environment = var.environment
  department  = var.department

  vnet_address_space       = var.vnet_address_space
  appgateway_subnet_prefix = var.appgateway_subnet_prefix
  apimgmt_subnet_prefix    = var.apimgmt_subnet_prefix
  bastion_subnet_prefix    = var.bastion_subnet_prefix
  private_subnet_prefix    = var.private_subnet_prefix
  aks_node_subnet_prefix   = var.aks_node_subnet_prefix
}

module "aks" {
  source = "./aks"

  location                   = var.location
  environment                = var.environment
  department                 = var.department
  log_analytics_workspace_id = module.logging.log_analytics_workspace_id

  nodepool_subnet_id = module.vnet.aks_node_subnet_id
  pod_cidr           = var.pod_cidr
  service_cidr       = var.service_cidr
  dns_service_ip     = var.dns_service_ip
  docker_bridge_cidr = var.docker_bridge_cidr
}