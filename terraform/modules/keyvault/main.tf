data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.sku_name

  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = true

  enable_rbac_authorization = var.rbac_authorization_enabled

  tags = var.tags
}

resource "azurerm_role_assignment" "secret_writer" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.clientid_secret_writer_principal_id
}

resource "azurerm_role_assignment" "secret_reader" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.secret_reader_principal_id
}

# data "azurerm_key_vault_secret" "mongo_connstr" {
#   name         = "mongo-connection-string"
#   key_vault_id = azurerm_key_vault.kv.id
# }

# data "azurerm_key_vault_secret" "mongo_db_name" {
#   name         = "mongo-db-name"
#   key_vault_id = azurerm_key_vault.kv.id
#   depends_on   = [azurerm_key_vault.kv, azurerm_role_assignment.secret_writer]
# }

# resource "azurerm_key_vault_secret" "mongo_db_name" {
#   name         = "mongo-db-name"
#   value        = var.mongo_db_name
#   key_vault_id = azurerm_key_vault.kv.id
#   depends_on   = [azurerm_key_vault.kv, azurerm_role_assignment.secret_writer]
# }

# resource "azurerm_key_vault_secret" "redis_host" {
#   name         = "redis-host"
#   value        = var.redis_host
#   key_vault_id = azurerm_key_vault.kv.id
#   depends_on   = [azurerm_key_vault.kv, azurerm_role_assignment.secret_writer]
# }

# resource "azurerm_key_vault_secret" "weather_api_key" {
#   name         = "weather-api-key"
#   value        = var.weather_api_key
#   key_vault_id = azurerm_key_vault.kv.id
#   depends_on   = [azurerm_key_vault.kv, azurerm_role_assignment.secret_writer]
# }


data "azurerm_key_vault_secret" "secrets" {
  for_each    = local.kv_secrets
  name        = each.value
  key_vault_id = azurerm_key_vault.kv.id
  depends_on  = [azurerm_key_vault.kv, azurerm_role_assignment.secret_writer]
}
