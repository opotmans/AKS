
resource "azurerm_resource_group" "aks_rg" {
  name     = "${var.resource_name}-rg"
  location = var.location
}