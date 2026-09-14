resource "azurerm_private_dns_zone" "this" {
  for_each = toset(var.zones)

  name                = each.value
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = {
    for pair in setproduct(toset(var.zones), keys(var.virtual_network_ids)) :
    "${pair[0]}|${pair[1]}" => {
      zone_name = pair[0]
      vnet_key  = pair[1]
    }
  }

  name                  = "link-${replace(each.value.vnet_key, "_", "-")}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this[each.value.zone_name].name
  virtual_network_id    = var.virtual_network_ids[each.value.vnet_key]
  registration_enabled  = false
  tags                  = var.tags
}
