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