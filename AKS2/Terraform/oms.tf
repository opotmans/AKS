  
resource "random_integer" "log_analytics_workspace_name_suffix" {
    min = 1
    max = 50000
}

resource "azurerm_log_analytics_workspace" "clusterinsightsworkspace" {
  name                = "${var.log_analytics_workspace_name}${random_integer.log_analytics_workspace_name_suffix.result}"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  retention_in_days   = 30

   lifecycle {
        ignore_changes = [
            name,
        ]
    }
}

resource "azurerm_log_analytics_solution" "clusterinsightssolution" {
    solution_name         = "ContainerInsights"
    location              = azurerm_log_analytics_workspace.clusterinsightsworkspace.location
    resource_group_name   = azurerm_resource_group.aks_rg.name
    workspace_resource_id = azurerm_log_analytics_workspace.clusterinsightsworkspace.id
    workspace_name        = azurerm_log_analytics_workspace.clusterinsightsworkspace.name

    plan {
        publisher = "Microsoft"
        product   = "OMSGallery/ContainerInsights"
    }
}