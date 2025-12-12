output "key_vault_id" {
  value = azurerm_key_vault.kv.id
}

output "key_vault_name" {
  value = azurerm_key_vault.kv.name
}

output "key_vault_secret_ids" {
  value = {
    for key, secret in data.azurerm_key_vault_secret.secrets :
    key => secret.id
  }
}