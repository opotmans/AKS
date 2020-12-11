terraform {
   required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">=1.9.4"
    }
  }
}
/* 
provider "azurerm" {
  features {}
} */