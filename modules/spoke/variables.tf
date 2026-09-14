variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "address_space" {
  type = list(string)
}

variable "subnets" {
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
}

variable "firewall_private_ip" {
  type        = string
  description = "Next-Hop der Default-Route."
}

variable "dns_servers" {
  type        = list(string)
  default     = []
  description = "Typisch die Firewall-IP (DNS-Proxy). Leer = Azure-provided DNS."
}

variable "tags" {
  type    = map(string)
  default = {}
}
