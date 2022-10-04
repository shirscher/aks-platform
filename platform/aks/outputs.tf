output "host" {          
  value = azurerm_kubernetes_cluster.aks.kube_config.0.host 
}

output "username" {               
  value = azurerm_kubernetes_cluster.aks.kube_config.0.username
  sensitive = true
}

output "password" {               
  value = azurerm_kubernetes_cluster.aks.kube_config.0.password
  sensitive = true
}

output "client_certificate" {     
  value = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  sensitive = true
}

output "client_key" {             
  value = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  sensitive = true
}

output "cluster_ca_certificate" { 
  value = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  sensitive = true
}
