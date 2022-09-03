output "private_subnet_id" {
  value = azurerm_subnet.private_subnet.id
}

output "aks_node_subnet_id" {
  value = azurerm_subnet.aks_node_subnet.id
}