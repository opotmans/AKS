resource "azurerm_container_registry" "acr" {
  name                     = "${var.resource_name}${var.acr_name}"
  resource_group_name      = azurerm_resource_group.aks_rg.name
  location                 = azurerm_resource_group.aks_rg.location
  sku                      = "Basic"
  admin_enabled            = true

  provisioner "local-exec" {
    command = "az acr import -n ${azurerm_container_registry.acr.name} --source docker.io/library/nginx:latest --image hello-world:latest"
    //interpreter = ["Powershell", "-Command"] 
  }

}