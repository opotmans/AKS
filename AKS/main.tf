# Configure the Azure provider

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "simple_vm" {
  name     = "simple_vm"
  location = "westeurope"
}

resource "azurerm_virtual_network" "main" {
  name                = "main"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.simple_vm.location
  resource_group_name = azurerm_resource_group.simple_vm.name

  subnet {
    name = "subnet_1"
    address_prefix = "10.0.0.0/24" 
  }
}

resource "azurerm_subnet" "demo" {
  name                 = "subnet_2"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = azurerm_resource_group.simple_vm.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_container_registry" "acr" {
  name                     = "acrnametest01"
  resource_group_name      = azurerm_resource_group.simple_vm.name
  location                 = azurerm_resource_group.simple_vm.location
  sku                      = "Basic"
  admin_enabled            = true
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "example-aks1"
  location            = azurerm_resource_group.simple_vm.location
  resource_group_name = azurerm_resource_group.simple_vm.name
  dns_prefix          = "exampleaks1"
  sku_tier             = "Free"


  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
    //availability_zones  = ["1", "2"]
    //enable_auto_scaling = true
    //min_count           = 2
    //max_count           = 4
    //vnet_subnet_id = azurerm_subnet.demo.id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Demo"
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.example.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.example.kube_config_raw
}