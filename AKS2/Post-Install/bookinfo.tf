resource "null_resource" "label_namespace" {
    provisioner "local-exec" {
        command = "kubectl label namespace default istio-injection=enabled --kubeconfig .kube/${azurerm_kubernetes_cluster.aks_cluster.name}}"
    }
        depends_on = [null_resource.istio]
} 

resource "null_resource" "bookinfo" {
    provisioner "local-exec" {
        command = "kubectl.exe apply -f istio/istio_bin/samples/bookinfo/platform/kube/bookinfo.yaml -n default --kubeconfig .kube/${azurerm_kubernetes_cluster.aks_cluster.name}"
    }
        depends_on = [null_resource.label_namespace]
} 

resource "null_resource" "gateway" {
    provisioner "local-exec" {
        command = "kubectl.exe apply -f istio/istio_bin/samples/bookinfo/networking/bookinfo-gateway.yaml -n default --kubeconfig .kube/${azurerm_kubernetes_cluster.aks_cluster.name}"
    }
        depends_on = [null_resource.bookinfo]
} 

resource "null_resource" "destination-rule-all" {
    provisioner "local-exec" {
        command = "kubectl.exe apply -f istio/istio_bin/samples/bookinfo/networking/destination-rule-all.yaml -n default --kubeconfig .kube/${azurerm_kubernetes_cluster.aks_cluster.name}"
    }
        depends_on = [null_resource.gateway]
} 