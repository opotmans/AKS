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

resource "null_resource" "bookinfo" {
  provisioner "local-exec" {
    command = "${path.module}/../bin/kubectl.exe apply -f ${path.module}/YamlFiles/bookinfo.yaml -n ${var.environment} --kubeconfig .kube/${var.aks_config_file}"
    interpreter = ["PowerShell", "-Command"]
  }
  depends_on = [kubernetes_namespace.env]
}

resource "null_resource" "bookinfo_gateway" {
  provisioner "local-exec" {
    command = "${path.module}/../bin/kubectl.exe apply -f ${path.module}/YamlFiles/bookinfo_gateway.yaml -n ${var.environment} --kubeconfig .kube/${var.aks_config_file}"
    interpreter = ["PowerShell", "-Command"]
  }
  depends_on = [kubernetes_namespace.env]
}