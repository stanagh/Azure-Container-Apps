resource "azurerm_dns_zone" "dns_zone" {
  name                = var.dns_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_dns_cname_record" "cname_record" {
  name                = var.cname_record_name
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  record              = var.cname_record_value
}



