resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

#
# VNet
#
resource "azurerm_virtual_network" "vnet" {
  name                = format("vnet-datacenter-p01")
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    Environment = var.environment.name
  }
}

resource "azurerm_subnet" "dmz_subnet" {
  name                 = "DmzSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.dmz_subnet_prefix]
}

resource "azurerm_subnet" "internal_subnet" {
  name                 = "InternalSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.internal_subnet_prefix]
}

#
# Linux VPN
#

#
# Active Directory Server
#
module "virtual-machine" {
  source  = "kumarvna/active-directory-forest/azurerm"
  version = "2.1.0"

  # Resource Group, location, VNet and Subnet details
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  virtual_network_name = azurerm_virtual_network.vnet.name
  subnet_name          = azurerm_subnet.internal_subnet

  # This module support multiple Pre-Defined Linux and Windows Distributions.
  # Windows Images: windows2012r2dc, windows2016dc, windows2019dc
  virtual_machine_name               = "vm-win-dc-p01"
  windows_distribution_name          = "windows2019dc"
  virtual_machine_size               = "Standard_A2_v2"
  admin_username                     = var.domain_admin_username
  admin_password                     = var.domain_admin_password
  private_ip_address_allocation_type = "Static"
  private_ip_address                 = [var.domain_controller_ip]

  # Active Directory domain and netbios details
  # Intended for test/demo purposes
  # For production use of this module, fortify the security by adding correct nsg rules
  active_directory_domain       = "omnicorp.local"
  active_directory_netbios_name = "OMNI"

  # Network Seurity group port allow definitions for each Virtual Machine
  # NSG association to be added automatically for all network interfaces.
  # SSH port 22 and 3389 is exposed to the Internet recommended for only testing.
  # For production environments, we recommend using a VPN or private connection
  nsg_inbound_rules = [
    {
      name                   = "rdp"
      destination_port_range = "3389"
      source_address_prefix  = "*"
    },

    {
      name                   = "dns"
      destination_port_range = "53"
      source_address_prefix  = "*"
    },
  ]
}

#
# Windows IIS Server
#
resource "azurerm_virtual_machine_extension" "vm_extension_install_iis" {
  name                       = "vm-win-web-p01"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools"
    }
SETTINGS
}