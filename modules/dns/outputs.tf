output "zone_ids" {
  value = { for k, z in azurerm_private_dns_zone.this : k => z.id }
}

output "zone_names" {
  value = { for k, z in azurerm_private_dns_zone.this : k => z.name }
}
