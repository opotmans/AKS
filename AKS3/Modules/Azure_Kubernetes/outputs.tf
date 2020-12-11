output "aks_config_file_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.name
}

output "aks_host" {
  value =  azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
}

output "aks_username" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.username
}

output "aks_password" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.password
}

output "aks_client_certificate" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate
}

output "aks_client_key" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_key
}

output "aks_ca_certificate" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.cluster_ca_certificate
}