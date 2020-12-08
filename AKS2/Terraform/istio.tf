/* resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
} */

/* data "azurerm_subscription" "current" {
} */

/* resource "local_file" "kube_config" {
  content    = azurerm_kubernetes_cluster.aks_cluster.kube_admin_config_raw
  filename   = ".kube/config"   
}  */


/* resource "null_resource" "set-kube-config" {
  triggers = {
    always_run = timestamp()
  }

/*   provisioner "local-exec" {
    command = "az aks get-credentials -n ${azurerm_kubernetes_cluster.aks_cluster.name} -g ${azurerm_resource_group.aks_rg.name} --file \".kube/${azurerm_kubernetes_cluster.aks_cluster.name}\" --admin --overwrite-existing"
  }
  depends_on = [local_file.kube_config]
}  */



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
  content = templatefile("istio/istio-aks.tmpl", {
    enableGrafana = true
    enableKiali   = true
    enableTracing = true
  })
  filename = "istio/istio-aks.yaml"
}

resource "null_resource" "istio" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "istio/istio_bin/bin/istioctl.exe manifest apply -f istio/istio-aks.yaml --kubeconfig .kube/${azurerm_kubernetes_cluster.aks_cluster.name}"
    interpreter = ["PowerShell", "-Command"]
  }
  depends_on = [kubernetes_secret.grafana, kubernetes_secret.kiali, local_file.istio-config]
}

//istio/istio_bin/bin/istioctl.exe manifest apply -f istio/istio-aks.yaml --kubeconfig .kube/testAKS2Cluster