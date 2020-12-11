provider "kubernetes" {
load_config_file = "false"
host = var.aks_host
username = var.aks_username
password = var.aks_password
client_certificate = base64decode(var.aks_client_certificate)
client_key = base64decode(var.aks_client_key)
cluster_ca_certificate = base64decode(var.aks_ca_certificate)
}

provider "kubectl" {
  load_config_file = "false"
  host = var.aks_host
  username = var.aks_username
  password = var.aks_password
  client_certificate = base64decode(var.aks_client_certificate)
  client_key = base64decode(var.aks_client_key)
  cluster_ca_certificate = base64decode(var.aks_ca_certificate)
}

resource "kubernetes_namespace" "env" {
  metadata {
    name = var.environment
    labels = {
      istio-injection = "enabled"
    }
  }
}

resource "kubectl_manifest" "bookinfo" {
  override_namespace = kubernetes_namespace.env.metadata[0].name
  yaml_body = file ("${path.module}/YamlFiles/nginx.yaml")
  depends_on = [ kubernetes_namespace.env]
}

