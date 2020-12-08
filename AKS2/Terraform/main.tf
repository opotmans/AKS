// Code written by Olivier Potmans 
// Objectives:

provider "azurerm" {
  features {}
}

terraform {
   required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">=1.9.4"
    }
  }
}