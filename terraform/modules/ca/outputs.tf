output "custom_domain_verification_id" {
  description = "The custom domain verification ID of the Container App"
  value       = azurerm_container_app.ca.custom_domain_verification_id
}

output "container_app_id_principal_id" {
  description = "The object ID of the Container App's managed identity"
  value       = azurerm_container_app.ca.identity[0].principal_id
}

output "container_app_id" {
  description = "The ID of the Container App"
  value       = azurerm_container_app.ca.id
}

output "ca_latest_revision_fqdn" {
  description = "The FQDN of the latest revision of the Container App" 
  value       = azurerm_container_app.ca.latest_revision_fqdn
}