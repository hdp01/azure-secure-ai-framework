provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-vision-secure-demo"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-secure"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "snet" {
  name                 = "snet-private-endpoints"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  private_endpoint_network_policies = "Enabled"
}

resource "azurerm_private_dns_zone" "dns_vision" {
  name                = "privatelink.cognitiveservices.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  name                  = "dns-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns_vision.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_cognitive_account" "vision" {
  name                          = "ai-vision-secure-harsh" 
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  kind                          = "ComputerVision"
  sku_name                      = "S1"
  
  custom_subdomain_name         = "vision-secure-harsh-v1" 

  public_network_access_enabled = false
  local_auth_enabled            = false 
}

resource "azurerm_private_endpoint" "vision_pe" {
  name                = "pe-vision"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.snet.id

  private_service_connection {
    name                           = "vision-connection"
    private_connection_resource_id = azurerm_cognitive_account.vision.id
    is_manual_connection           = false
    subresource_names              = ["account"]
  }

  private_dns_zone_group {
    name                 = "vision-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.dns_vision.id]
  }
}

resource "azurerm_storage_account" "store" {
  name                     = "stvisionsecureharsh2026" 
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  public_network_access_enabled = false 
}