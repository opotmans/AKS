provider "kubernetes" {
load_config_file = "false"
host = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
username = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.username
password = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.password
client_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate)
client_key = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_key)
cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.cluster_ca_certificate)
}

//Definition of a namespace "test"
resource "kubernetes_namespace" "example" {
  metadata {
    name = "test"
  }
  depends_on = [
    azurerm_kubernetes_cluster.aks_cluster,
  ]
}


//Definition of a secret to connect to the ACR
/* resource "kubernetes_secret" "acr" {
  metadata {
    name = "basic-auth"
    namespace = kubernetes_namespace.example.metadata.0.name
  }

  data = {
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }

  type = "kubernetes.io/basic-auth"

  depends_on = [
      azurerm_container_registry.acr,
  ]
} */

resource "kubernetes_pod" "nginx" {
  metadata {
    name = "nginx-example"
    namespace = kubernetes_namespace.example.metadata.0.name
    
    labels = {
      App = "nginx"
    }  
  }

  spec {
    container {
      image = "${azurerm_container_registry.acr.login_server}/hello-world:latest"
      name  = "nginxexample"

      port {
        container_port = 80
      }
    }
    /* image_pull_secrets {
      name = kubernetes_secret.acr.metadata.0.name
    } */
  }

  depends_on = [
      //kubernetes_secret.acr,
      kubernetes_namespace.example,
  ]

}