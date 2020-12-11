// Code written by Olivier Potmans 
// Objectives:

terraform {
   required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">=1.9.4"
    }
  }
}

provider "azurerm" {
  features {}
}

module "Azure_Kubernetes" {
  source = "./Modules/Azure_Kubernetes"
  resource_name = "testAKS2"
  location = "West Europe"
  log_analytics_workspace_name = "LogAnalyticsworkspace"
  acr_name = "AzureContainerRegistry"

  //Configuration addons of Azure Kubernetes Services

  //kubernetes_version= "1.17.8"

  sku_tier = "Free"

  addons = {
    oms_agent = true
    kubernetes_dashboard = true
    azure_policy = false
  }
}
module "Istio_Infra" {
  source = "./Modules/Istio_Infra"
  aks_config_file = module.Azure_Kubernetes.aks_config_file_name
  aks_host = module.Azure_Kubernetes.aks_host
  aks_username =  module.Azure_Kubernetes.aks_username
  aks_password =  module.Azure_Kubernetes.aks_password
  aks_client_certificate =  module.Azure_Kubernetes.aks_client_certificate
  aks_client_key = module.Azure_Kubernetes.aks_client_key
  aks_ca_certificate = module.Azure_Kubernetes.aks_ca_certificate
}

module "Bookinfo" {
  source = "./Modules/Applications/Bookinfo"
  aks_config_file = module.Azure_Kubernetes.aks_config_file_name
  aks_host = module.Azure_Kubernetes.aks_host
  aks_username =  module.Azure_Kubernetes.aks_username
  aks_password =  module.Azure_Kubernetes.aks_password
  aks_client_certificate =  module.Azure_Kubernetes.aks_client_certificate
  aks_client_key = module.Azure_Kubernetes.aks_client_key
  aks_ca_certificate = module.Azure_Kubernetes.aks_ca_certificate
  environment = "bookinfo"
}



