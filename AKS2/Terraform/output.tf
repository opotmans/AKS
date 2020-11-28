output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config
}

output "fqdn" {
  value = azurerm_kubernetes_cluster.aks_cluster.fqdn
}

# output "http_routing" {
#   value = azurerm_kubernetes_cluster.aks_cluster.http_application_routing
# }

output "identity" {
  value = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity
}



