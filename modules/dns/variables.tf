variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "zones" {
  type        = list(string)
  default     = ["privatelink.blob.core.windows.net"]
  description = "Weitere PaaS-Zonen später ergänzen (acr, sql), nicht wild wachsen lassen."
}

variable "virtual_network_ids" {
  type        = map(string)
  description = "Alle VNets, die auflösen müssen: hub, spoke-app, spoke-aks."
  default     = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
