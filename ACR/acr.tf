

resource "azurerm_resource_group" "acr_rg" {
  name     = "acrrg01"
  location = "West Europe"
}

resource "azurerm_container_registry" "acr" {
  name                     = "acrregistry01"
  resource_group_name      = azurerm_resource_group.acr_rg.name
  location                 = azurerm_resource_group.acr_rg.location
  sku                      = "Basic"
  admin_enabled            = true

  provisioner "local-exec" {
    command = "az acr import -n ${azurerm_container_registry.acr.name} --source docker.io/library/nginx:latest --image hello-world:latest"
    //interpreter = ["Powershell", "-Command"] 
  }
}
