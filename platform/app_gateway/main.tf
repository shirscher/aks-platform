resource "azurerm_public_ip" "public_ip" {
  name                = "pip-${var.app_gateway_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic" # Static IP not supported by Standard tier
}

resource "azurerm_application_gateway" "appgateway" {
  name                = var.app_gateway_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "http-frontend-port"
    port = 80
  }
  #frontend_port {
  #  name = "https-frontend-port"
  #  port = 443
  #}

  frontend_ip_configuration {
    name                 = "public-frontend-ip-config"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }

  backend_address_pool {
    name = "aks-backend-address-pool"
  }

  backend_http_settings {
    name                  = "aks-backend-http-settings"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    # TODO: Probe
  }

  http_listener {
    name                           = "public-http-listener"
    frontend_ip_configuration_name = "public-frontend-ip-config"
    frontend_port_name             = "http-frontend-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "public-http-aks-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "public-http-listener"
    backend_address_pool_name  = "aks-backend-address-pool"
    backend_http_settings_name = "aks-backend-http-settings"
  }
}