resource "azurerm_public_ip" "this" {
  name                = "pip-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_firewall_policy" "this" {
  name                = "afwp-${trimprefix(var.name, "afw-")}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku_tier
  tags                = var.tags

  dns {
    proxy_enabled = true
  }

  threat_intelligence_mode = "Alert"
}

resource "azurerm_firewall_policy_rule_collection_group" "lab" {
  name               = "rcg-lab"
  firewall_policy_id = azurerm_firewall_policy.this.id
  priority           = 200

  network_rule_collection {
    name     = "allow-spoke-to-spoke"
    priority = 200
    action   = "Allow"

    rule {
      name                  = "rfc1918-lab-spokes"
      protocols             = ["Any"]
      source_addresses      = var.spoke_cidrs
      destination_addresses = var.spoke_cidrs
      destination_ports     = ["*"]
    }
  }

  network_rule_collection {
    name     = "allow-dns-ntp"
    priority = 300
    action   = "Allow"

    rule {
      name                  = "dns"
      protocols             = ["TCP", "UDP"]
      source_addresses      = var.spoke_cidrs
      destination_addresses = ["*"]
      destination_ports     = ["53"]
    }

    rule {
      name                  = "ntp"
      protocols             = ["UDP"]
      source_addresses      = var.spoke_cidrs
      destination_addresses = ["*"]
      destination_ports     = ["123"]
    }
  }

  application_rule_collection {
    name     = "allow-lab-web"
    priority = 400
    action   = "Allow"

    rule {
      name              = "example-com"
      source_addresses  = var.spoke_cidrs
      destination_fqdns = ["example.com", "www.example.com"]

      protocols {
        type = "Http"
        port = 80
      }

      protocols {
        type = "Https"
        port = 443
      }
    }
  }
}

resource "azurerm_firewall" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = "AZFW_VNet"
  sku_tier            = var.sku_tier
  firewall_policy_id  = azurerm_firewall_policy.this.id
  private_ip_ranges   = ["IANAPrivateRanges"]
  tags                = var.tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.this.id
  }

  depends_on = [azurerm_firewall_policy_rule_collection_group.lab]
}
