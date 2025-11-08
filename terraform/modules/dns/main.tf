resource "azurerm_dns_zone" "dns_zone" {
  name                = var.dns_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_public_ip" "pip" {
  name                = var.public_ip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = var.public_ip_sku
  tags                = var.tags
}

resource "azurerm_dns_a_record" "a_record" {
  name                = var.a_record_name
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  records             = var.records
  depends_on          = [azurerm_public_ip.pip]
}

