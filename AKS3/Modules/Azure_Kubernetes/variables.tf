
// Definition of the ressource group including the location
variable "resource_name" {
  type        = string
  description = "(Required) Prefix given to all resources within the module."
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  default     = "West Europe"
}

// Definition of the virtual network and the subnets


// List of variables for the Log Analytics OMS Workspace
//variable "log_analytics_workspace_resource_id" {
//  type        = string
//  description = "(Required) Resource ID of the Log Analytics workspace for storing Azure Monitor metrics"
//}

variable log_analytics_workspace_name {
    description = "The name of the Log Analytics workspace."
    default     = "aks_monitor"
}

// List of variables for the Azure Container Registry 

variable acr_name {
  type = string
  description = "(Required) the name of the azure container registry instance"
}

// List of variables for the Azure Kubernetes Service
variable sku_tier {
  type = string
  description = "the type of the contract"
}

variable "kubernetes_version" {
  type        = string
  default     = "1.18.10"
  description = "Version of Kubernetes specified when creating the AKS managed cluster. If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade)."
}

variable "system_node_pool" {
  description = "The object to configure the default system node pool with number of worker nodes, worker node VM size and Availability Zones."
  type = object({
    name                           = string
    node_count                     = number 
    vm_size                        = string
    zones                          = list(string)
    labels                         = map(string)
    taints                         = list(string)
    cluster_auto_scaling           = bool
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number
  })

  default = {
      node_count                        = 1
      vm_size                           = "Standard_DS4_v2"
      cluster_auto_scaling_min_count    = 3
      cluster_auto_scaling_max_count    = 5
      cluster_auto_scaling              = false
      labels                            = {}
      name                              = "system-node-pool"
      taints                            = ["CriticalAddonsOnly=true:NoSchedule"]
      zones                             = ["1", "2"]
  }
}


variable "service_cidr" {
  type        = string
  default     = "100.64.0.0/16"
  description = "The Network Range used by the Kubernetes service. This range should not be used by any network element on or connected to this virtual network. Service address CIDR must be smaller than /12."
}

variable "dns_service_ip" {
  type        = string
  default     = "100.64.0.10"
  description = "IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Don't use the first IP address in your address range, such as .1. The first address in your subnet range is used for the kubernetes.default.svc.cluster.local address. Changing this forces a new resource to be created."
}

variable "docker_cidr" {
  type        = string
  default     = "100.65.0.1/16"
  description = "IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Changing this forces a new resource to be created."
}

variable "addons" {
  description = "Defines which addons will be activated."
  type = object({
    oms_agent            = bool
    kubernetes_dashboard = bool
    azure_policy         = bool
  })
}