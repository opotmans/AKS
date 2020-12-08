resource "local_file" "foo" {
    content     = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
    filename = ".kube/${azurerm_kubernetes_cluster.aks_cluster.name}"

    depends_on = [azurerm_kubernetes_cluster.aks_cluster]
}

/* 

  provisioner "local-exec" {
    command = "echo \"${azurerm_kubernetes_cluster.aks_cluster.kube_confi_raw}\" > .kube/${azurerm_kubernetes_cluster.aks_cluster.name} "
  }
  depends_on = [azurerm_kubernetes_cluster.aks_cluster]
} 
*/