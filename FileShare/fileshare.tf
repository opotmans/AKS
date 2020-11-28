resource "azurerm_resource_group" "AFSrg" {
  name     = "FS01"
  location = "West Europe"
}

resource "azurerm_storage_account" "lab" {
  name                     = "storageaccounterra"
  resource_group_name      = azurerm_resource_group.AFSrg.name
  location                 = azurerm_resource_group.AFSrg.location 
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

/* resource "azurerm_storage_container" "lab" {
  name                  = "blobcontainer4lab"
  storage_account_name  = azurerm_storage_account.lab.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "lab" {
  name                   = "TerraformBlob"
  storage_account_name   = azurerm_storage_account.lab.name
  storage_container_name = azurerm_storage_container.lab.name
  type                   = "Block" 
}*/
resource "azurerm_storage_share" "lab" {
  name                 = "terraformshare"  
  storage_account_name = azurerm_storage_account.lab.name
  quota                = 50
}

resource "azurerm_storage_share_directory" "example" {
  name                 = "firstdir"
  share_name           = azurerm_storage_share.lab.name
  storage_account_name = azurerm_storage_account.lab.name
}

output "web_access" {
    value = azurerm_storage_account.lab.primary_web_endpoint
} 

output "primary_access_key" {
    value = azurerm_storage_account.lab.primary_access_key
}

//output "connectionstring" {
//    value = azurerm_storage_account.lab.connection_string
//}