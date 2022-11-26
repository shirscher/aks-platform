module "globals" {
  source = ./globals
}

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
  app_gateway_subnet_prefix = var.app_gateway_subnet_prefix
  apimgmt_subnet_prefix    = var.apimgmt_subnet_prefix
  bastion_subnet_prefix    = var.bastion_subnet_prefix
  private_subnet_prefix    = var.private_subnet_prefix
  aks_node_subnet_prefix   = var.aks_node_subnet_prefix
}

module "aks" {
  source = "./aks"

  resource_group_name = local.aks_resource_group_name
  name                = local.aks_name

  location                   = var.location
  environment                = var.environment
  department                 = var.department
  log_analytics_workspace_id = module.logging.log_analytics_workspace_id

  nodepool_subnet_id       = module.vnet.aks_node_subnet_id
  node_resource_group_name = local.aks_node_resource_group_name

  pod_cidr           = var.pod_cidr
  service_cidr       = var.service_cidr
  dns_service_ip     = var.dns_service_ip
  docker_bridge_cidr = var.docker_bridge_cidr
}

module "ingress_nginx" {
  depends_on = [module.aks]
  source     = "./ingress_nginx"

  aks_cluster_identity_principal_id = module.aks.cluster_identity_principal_id
  node_pool_subnet_id               = module.vnet.aks_node_subnet_id
}

module "app_gateway" {
  source = "./app_gateway"

  location            = var.location
  resource_group_name = "rg-omni-network-p01"
  app_gateway_name    = local.app_gateway_name
  subnet_id           = module.vnet.app_gateway_subnet_id
  load_balancer_ip    = module.ingress_nginx.load_balancer_ip
}

# module "api_management_internal"
# module "api_management_external"