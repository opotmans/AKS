provider "kubectl" {
  host                   =  azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.cluster_ca_certificate)
  username = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.username
  password = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.password
  client_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate)
  client_key = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_key)
  load_config_file       = false
}

resource "kubectl_manifest" "azure_file_storageclass" {
  yaml_body = file ("${path.module}/YamlFiles/azure_file_storageclass.yaml")
}

/* resource "kubectl_manifest" "azure_file_pvc" {
    yaml_body = file("../Post-Install/azure_file_pvc.yaml")
} */