output "key_vault_id" {
  value = azurerm_key_vault.kv.id
}

output "key_vault_name" {
  value = azurerm_key_vault.kv.name
}

# output "mongo_connstr_secret_id" {
#   value = azurerm_key_vault_secret.mongo_connstr.id
# }

# output "mongo_db_name_secret_id" {
#   value = azurerm_key_vault_secret.mongo_db_name.id
# }

# output "redis_host_secret_id" {
#   value = azurerm_key_vault_secret.redis_host.id
# }

# output "weather_api_key_secret_id" {
#   value = azurerm_key_vault_secret.weather_api_key.id
# }

output "key_vault_secret_ids" {
  value = {
    for key, secret in data.azurerm_key_vault_secret.secrets :
    key => secret.id
  }
}