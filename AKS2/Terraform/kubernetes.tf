provider "kubernetes" {
load_config_file = "false"
host = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
username = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.username
password = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.password
client_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate)
client_key = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_key)
cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.cluster_ca_certificate)
}

//Definiion of a namespace "test"
resource "kubernetes_namespace" "example" {
  metadata {
    name = "test"
  }
  depends_on = [
    azurerm_kubernetes_cluster.aks_cluster,
  ]
}


//Definition of a secret to connect to the ACR
ressource "kubernetes_secret" "acr" {
  metadata {
    name = "basic-auth"
  }

  data = {
    username = "${azurerm_container_registry.acr.admin_username}"
    password = "${azurerm_container_registry.acr.admin_password}"
  }

  type = "kubernetes.io/basic-auth"

  depend_on = [
      azurerm_container_registry.acr,
  ]
}