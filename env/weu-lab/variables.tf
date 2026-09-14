variable "location" {
  type    = string
  default = "westeurope"
}

variable "location_short" {
  type    = string
  default = "weu"
}

variable "prefix" {
  type        = string
  default     = "azhs"
  description = "Nur klein, kurz; Teil des Storage-Namens."
}

variable "probe_vm_size" {
  type    = string
  default = "Standard_B2s"
}

variable "probe_admin_username" {
  type    = string
  default = "azadmin"
}

variable "tags" {
  type = map(string)
  default = {
    project = "az-hubspoke-weu"
    env     = "lab"
    destroy = "ephemeral"
  }
}
