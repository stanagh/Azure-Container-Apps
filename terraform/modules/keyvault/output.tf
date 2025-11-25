output "key_vault_id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.keyvault.id
}

output "key_vault_name" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.keyvault.name
}

output "mongo-db-name_secret_id" {
  description = "The ID of the MongoDB database name secret in Key Vault"
  value       = azurerm_key_vault_secret.mongo-db-name.id

}

output "mongo-connstr_secret_id" {
  description = "The ID of the MongoDB connection string secret in Key Vault"
  value       = azurerm_key_vault_secret.mongo_connstr.id
}

output "weather-api-key_secret_id" {
  description = "The ID of the Weather API key secret in Key Vault"
  value       = azurerm_key_vault_secret.weather_api_key.id
}