resource "azurerm_resource_group" "hub" {
  name     = local.names.rg_hub
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "app" {
  name     = local.names.rg_app
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "aks" {
  name     = local.names.rg_aks
  location = var.location
  tags     = var.tags
}

module "hub" {
  source              = "../../modules/hub"
  name                = local.names.vnet_hub
  resource_group_name = azurerm_resource_group.hub.name
  location            = var.location
  address_space       = ["10.20.0.0/22"]
  subnets             = local.hub_subnets
  tags                = var.tags
}

module "firewall" {
  source              = "../../modules/firewall"
  name                = local.names.fw
  resource_group_name = azurerm_resource_group.hub.name
  location            = var.location
  subnet_id           = module.hub.subnet_ids["firewall"]
  sku_tier            = "Standard"
  spoke_cidrs         = local.spoke_cidrs
  tags                = var.tags
}

module "spoke_app" {
  source              = "../../modules/spoke"
  name                = local.names.vnet_app
  resource_group_name = azurerm_resource_group.app.name
  location            = var.location
  address_space       = ["10.20.16.0/24"]
  subnets             = local.app_subnets
  firewall_private_ip = module.firewall.private_ip
  dns_servers         = [module.firewall.private_ip]
  tags                = var.tags
}

module "spoke_aks" {
  source              = "../../modules/spoke"
  name                = local.names.vnet_aks
  resource_group_name = azurerm_resource_group.aks.name
  location            = var.location
  address_space       = ["10.20.32.0/22"]
  subnets             = local.aks_subnets
  firewall_private_ip = module.firewall.private_ip
  dns_servers         = [module.firewall.private_ip]
  tags                = var.tags
}

module "dns" {
  source              = "../../modules/dns"
  resource_group_name = azurerm_resource_group.hub.name
  location            = var.location
  zones               = ["privatelink.blob.core.windows.net"]
  virtual_network_ids = {
    hub  = module.hub.vnet_id
    app  = module.spoke_app.vnet_id
    aks  = module.spoke_aks.vnet_id
  }
  tags = var.tags
}
