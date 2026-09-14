variable "name" {
  type        = string
  description = "z. B. afw-hub-weu-01"
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "subnet_id" {
  type        = string
  description = "AzureFirewallSubnet ID aus module.hub"
}

variable "sku_tier" {
  type    = string
  default = "Standard"

  validation {
    condition     = contains(["Standard", "Premium"], var.sku_tier)
    error_message = "MVP ist Standard. Premium nur nach ADR-Änderung."
  }
}

variable "spoke_cidrs" {
  type        = list(string)
  description = "Quellen für Spoke-to-Spoke und Egress-Regeln."
  default     = ["10.20.16.0/24", "10.20.32.0/22"]
}

variable "tags" {
  type    = map(string)
  default = {}
}
