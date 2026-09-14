output "vnet_id" {
  value = azurerm_virtual_network.this.id
}

output "vnet_name" {
  value = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  value = { for k, s in azurerm_subnet.this : k => s.id }
}

output "subnet_ids_by_name" {
  value = { for k, s in azurerm_subnet.this : s.name => s.id }
}

output "route_table_id" {
  value = azurerm_route_table.this.id
}
