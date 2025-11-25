# output "frontdoor_profile_id" {
#   value = azurerm_cdn_frontdoor_profile.fd_profile.id
# }

output "frontdoor_custom_domain_id" {
  value = azurerm_cdn_frontdoor_custom_domain.fdcustom_domain.id
}

output "endpoint_fqdn" {
  value = azurerm_cdn_frontdoor_endpoint.fdendpoint.host_name
}
