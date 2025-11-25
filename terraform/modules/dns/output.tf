output "dns_zone_id" {
  description = "The ID of the DNS Zone"
  value       = azurerm_dns_zone.dns_zone.id
}

output "dns_name" {
  description = "The name of the DNS Zone"
  value       = azurerm_dns_zone.dns_zone.name

}