resource "azurerm_kubernetes_cluster" "aks_cluster" {
    name                            = "${var.resource_name}Cluster"
    location                        = azurerm_resource_group.aks_rg.location
    resource_group_name             = azurerm_resource_group.aks_rg.name
    dns_prefix                      = "${var.resource_name}akscluster"
   // kubernetes_version              = var.kubernetes_version
    node_resource_group             = "${var.resource_name}-worker"
    private_cluster_enabled         = false
    sku_tier                        = var.sku_tier

    //*TODO Validate the the configuration of the system pool
    #create system node pool
    default_node_pool {
        name                  = "default"
        orchestrator_version  = var.kubernetes_version
        node_count            = var.system_node_pool.node_count
        vm_size               = var.system_node_pool.vm_size
        type                  = "VirtualMachineScaleSets"
        //availability_zones    = var.system_node_pool.zones
        //max_pods              = 250
        // os_disk_size_gb       = 128
        node_labels           = var.system_node_pool.labels
        //node_taints           = var.system_node_pool.taints
        enable_auto_scaling   = var.system_node_pool.cluster_auto_scaling
        //min_count             = var.system_node_pool.cluster_auto_scaling_min_count
        //max_count             = var.system_node_pool.cluster_auto_scaling_max_count
        enable_node_public_ip = false
        #advanced networking
        vnet_subnet_id        = azurerm_subnet.aks_subnet.id
    }
    //*TODO: analyse how to integrate the AKS cluster in Azure AD and manages the RBAC from AD
    role_based_access_control {
        enabled = false

       // azure_active_directory {
       //  managed = true
       // }
    }

    identity {
        type = "SystemAssigned"
    }
    
    addon_profile {
        
        kube_dashboard {
            enabled = var.addons.kubernetes_dashboard
        }

        oms_agent {
            enabled                    = var.addons.oms_agent
            log_analytics_workspace_id = azurerm_log_analytics_workspace.clusterinsightsworkspace.id
        }
    }
}