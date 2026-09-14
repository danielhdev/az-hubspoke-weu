locals {
  loc = var.location_short

  names = {
    rg_hub      = "rg-conn-hub-${local.loc}-01"
    rg_app      = "rg-spoke-app-${local.loc}-01"
    rg_aks      = "rg-spoke-aks-${local.loc}-01"
    vnet_hub    = "vnet-hub-${local.loc}-01"
    vnet_app    = "vnet-spoke-app-${local.loc}-01"
    vnet_aks    = "vnet-spoke-aks-${local.loc}-01"
    fw          = "afw-hub-${local.loc}-01"
    vm          = "vm-probe-app-${local.loc}-01"
    nic         = "nic-probe-app-${local.loc}-01"
    nsg         = "nsg-probe-app-${local.loc}-01"
    pe          = "pe-st-blob-app-${local.loc}-01"
  }

  hub_subnets = {
    firewall = { name = "AzureFirewallSubnet", address_prefixes = ["10.20.0.0/26"] }
    gateway  = { name = "GatewaySubnet", address_prefixes = ["10.20.0.64/27"] }
    bastion  = { name = "AzureBastionSubnet", address_prefixes = ["10.20.0.96/26"] }
    shared   = { name = "snet-shared", address_prefixes = ["10.20.1.0/24"] }
  }

  app_subnets = {
    workload    = { name = "snet-workload", address_prefixes = ["10.20.16.0/26"] }
    privatelink = { name = "snet-privatelink", address_prefixes = ["10.20.16.64/27"] }
    mgmt        = { name = "snet-mgmt", address_prefixes = ["10.20.16.96/27"] }
  }

  aks_subnets = {
    system      = { name = "snet-aks-system", address_prefixes = ["10.20.32.0/23"] }
    user        = { name = "snet-aks-user", address_prefixes = ["10.20.34.0/24"] }
    ingress     = { name = "snet-aks-ingress", address_prefixes = ["10.20.35.0/26"] }
    privatelink = { name = "snet-aks-privatelink", address_prefixes = ["10.20.35.64/27"] }
  }

  spoke_cidrs = ["10.20.16.0/24", "10.20.32.0/22"]
}
