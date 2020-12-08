
provider "helm" {
  kubernetes {
    host = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
    username = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.username
    password = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.password
    client_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate)
    client_key = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.cluster_ca_certificate)
  }
}

resource "helm_release" "mydatabase" {
  name  = "mydatabase"
  repository = "https://charts.helm.sh/stable"
  chart = "stable/mysql"

 // set {
 //   name  = "mariadbUser"
 //   value = "foo"
 // }
}