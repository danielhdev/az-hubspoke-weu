resource "random_string" "sa" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_storage_account" "probe" {
  name                            = "st${var.prefix}${var.location_short}${random_string.sa.result}"
  resource_group_name             = azurerm_resource_group.app.name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  account_kind                    = "StorageV2"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = false
  https_traffic_only_enabled      = true
  tags                            = var.tags
}

resource "azurerm_private_endpoint" "blob" {
  name                = local.names.pe
  resource_group_name = azurerm_resource_group.app.name
  location            = var.location
  subnet_id           = module.spoke_app.subnet_ids["privatelink"]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-st-blob"
    private_connection_resource_id = azurerm_storage_account.probe.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "blob"
    private_dns_zone_ids = [module.dns.zone_ids["privatelink.blob.core.windows.net"]]
  }
}

resource "azurerm_network_security_group" "probe" {
  name                = local.names.nsg
  location            = var.location
  resource_group_name = azurerm_resource_group.app.name
  tags                = var.tags

  security_rule {
    name                       = "deny-internet-inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "probe" {
  name                = local.names.nic
  location            = var.location
  resource_group_name = azurerm_resource_group.app.name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.spoke_app.subnet_ids["workload"]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "probe" {
  network_interface_id      = azurerm_network_interface.probe.id
  network_security_group_id = azurerm_network_security_group.probe.id
}

resource "tls_private_key" "probe" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "probe" {
  name                            = local.names.vm
  resource_group_name             = azurerm_resource_group.app.name
  location                        = var.location
  size                            = var.probe_vm_size
  admin_username                  = var.probe_admin_username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.probe.id]
  tags                            = var.tags

  admin_ssh_key {
    username   = var.probe_admin_username
    public_key = tls_private_key.probe.public_key_openssh
  }

  os_disk {
    name                 = "osdisk-${local.names.vm}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  boot_diagnostics {}
}
