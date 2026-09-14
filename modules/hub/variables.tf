variable "name" {
  type        = string
  description = "VNet-Name, z. B. vnet-hub-weu-01."
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "address_space" {
  type        = list(string)
  default     = ["10.20.0.0/22"]
  description = "Hub-CIDR. Nicht ändern ohne docs/cidr.md."
}

variable "subnets" {
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
  default = {
    firewall = { name = "AzureFirewallSubnet", address_prefixes = ["10.20.0.0/26"] }
    gateway  = { name = "GatewaySubnet", address_prefixes = ["10.20.0.64/27"] }
    bastion  = { name = "AzureBastionSubnet", address_prefixes = ["10.20.0.96/26"] }
    shared   = { name = "snet-shared", address_prefixes = ["10.20.1.0/24"] }
  }
}

variable "tags" {
  type    = map(string)
  default = {}
}
