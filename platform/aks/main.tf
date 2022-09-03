#
# Resources
#

resource "azurerm_resource_group" "aks_rg" {
  name     = format("rg-%s-aks-%s01", var.department.short_name, var.environment.postfix)
  location = var.location
  tags = {
    Environment = var.environment.name
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = format("aks-%s-%s01", var.department.short_name, var.environment.postfix)
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = format("aks-%s-%s01", var.department.short_name, var.environment.postfix)
  #dns_prefix_private_cluster = format("aks-%s-%s01", var.department.short_name, var.environment.postfix)
  automatic_channel_upgrade = "patch" # rapid, node-image, stable, none
  #api_server_authorized_ip_ranges = [""]
  node_resource_group = format("%s-nodes", azurerm_resource_group.aks_rg.name)
  sku_tier            = "Free" # Free, Paid

  default_node_pool {
    # ignore_changes = [ 
    #   node_count # If auto-scaling is enabled, would want to ignore node count changes
    # ]

    name           = "default"
    node_count     = 2
    vm_size        = "standard_b4ms"
    vnet_subnet_id = var.nodepool_subnet_id

    enable_auto_scaling = false
    # min_count           = 2
    # max_count           = 5
    # auto_scaler_profile {
    # }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "kubenet"
    network_policy = "calico"

    dns_service_ip     = var.dns_service_ip
    docker_bridge_cidr = var.docker_bridge_cidr
    pod_cidr           = var.pod_cidr
    service_cidr       = var.service_cidr
  }

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }
}

resource "azurerm_resource_group" "acr_rg" {
  name     = format("rg-%s-acr-%s01", var.department.short_name, var.environment.postfix)
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = format("acr%s%s01", var.department.short_name, var.environment.postfix)
  resource_group_name = azurerm_resource_group.acr_rg.name
  location            = azurerm_resource_group.acr_rg.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_role_assignment" "acr_role_assignment" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}
