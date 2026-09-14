resource "azurerm_virtual_network_peering" "hub_to_app" {
  name                         = "peer-hub-to-spoke-app"
  resource_group_name          = azurerm_resource_group.hub.name
  virtual_network_name         = module.hub.vnet_name
  remote_virtual_network_id    = module.spoke_app.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "app_to_hub" {
  name                         = "peer-spoke-app-to-hub"
  resource_group_name          = azurerm_resource_group.app.name
  virtual_network_name         = module.spoke_app.vnet_name
  remote_virtual_network_id    = module.hub.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "hub_to_aks" {
  name                         = "peer-hub-to-spoke-aks"
  resource_group_name          = azurerm_resource_group.hub.name
  virtual_network_name         = module.hub.vnet_name
  remote_virtual_network_id    = module.spoke_aks.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "aks_to_hub" {
  name                         = "peer-spoke-aks-to-hub"
  resource_group_name          = azurerm_resource_group.aks.name
  virtual_network_name         = module.spoke_aks.vnet_name
  remote_virtual_network_id    = module.hub.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}
