provider "kubernetes" {
load_config_file = "false"
host = var.aks_host
username = var.aks_username
password = var.aks_password
client_certificate = base64decode(var.aks_client_certificate)
client_key = base64decode(var.aks_client_key)
cluster_ca_certificate = base64decode(var.aks_ca_certificate)
}

resource "kubernetes_namespace" "istio_system" {
 // provider = kubernetes.local
  metadata {
    name = "istio-system"
  }
}

resource "kubernetes_secret" "grafana" {
 // provider = kubernetes.local
  metadata {
    name      = "grafana"
    namespace = "istio-system"
    labels = {
      app = "grafana"
    }
  }
  data = {
    username   = "admin"
    //passphrase = random_password.password.result
    passphrase = "test123"
  }
  type       = "Opaque"
  depends_on = [kubernetes_namespace.istio_system]
}

resource "kubernetes_secret" "kiali" {
  // provider = kubernetes.local
  metadata {
    name      = "kiali"
    namespace = "istio-system"
    labels = {
      app = "kiali"
    }
  }
  data = {
    username   = "admin"
    //passphrase = random_password.password.result
    passphrase = "test123"
  }
  type       = "Opaque"
  depends_on = [kubernetes_namespace.istio_system]
}

//creation of the configuration file that the istio operator will use. This is based on a template which is converted into istio-aks.yaml
resource "local_file" "istio-config" {
  content = templatefile("${path.module}/config/istio-aks.tmpl", {
    enableGrafana = true
    enableKiali   = true
    enableTracing = true
  })
  filename = "${path.module}/config/istio-aks.yaml"
}

resource "null_resource" "istio" {
 /*  triggers = {
    always_run = timestamp()
  } */
  provisioner "local-exec" {
    command = "${path.module}/bin/istioctl.exe manifest apply -f ${path.module}/config/istio-aks.yaml --kubeconfig .kube/${var.aks_config_file}"
    interpreter = ["PowerShell", "-Command"]
  }
  depends_on = [kubernetes_secret.grafana, kubernetes_secret.kiali, local_file.istio-config]
}

//istio/istio_bin/bin/istioctl.exe manifest apply -f istio/istio-aks.yaml --kubeconfig .kube/testAKS2Cluster