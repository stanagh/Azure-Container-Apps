output "custom_domain_verification_id" {
  value = azurerm_container_app.container_app.custom_domain_verification_id
}

output "container_app_id_principal_id" {
  description = "The object ID of the Container App's managed identity"
  value       = azurerm_container_app.container_app.identity[0].principal_id
}

output "container_app_id" {
  description = "The ID of the Container App"
  value       = azurerm_container_app.container_app.id
}

output "ca_latest_revision_fqdn" {
  description = "The FQDN of the latest revision of the Container App"
  value       = azurerm_container_app.container_app.latest_revision_fqdn
}
