output "resource_groups" {
  value = {
    hub = azurerm_resource_group.hub.name
    app = azurerm_resource_group.app.name
    aks = azurerm_resource_group.aks.name
  }
}

output "firewall_private_ip" {
  value = module.firewall.private_ip
}

output "firewall_public_ip" {
  value = module.firewall.public_ip
}

output "probe_vm_name" {
  value = azurerm_linux_virtual_machine.probe.name
}

output "probe_vm_private_ip" {
  value = azurerm_network_interface.probe.private_ip_address
}

output "storage_account_name" {
  value = azurerm_storage_account.probe.name
}

output "storage_blob_fqdn" {
  value = "${azurerm_storage_account.probe.name}.blob.core.windows.net"
}

output "probe_ssh_private_key" {
  value       = tls_private_key.probe.private_key_openssh
  sensitive   = true
  description = "Nur Fallback. Demo läuft über az vm run-command, ohne Public IP."
}
