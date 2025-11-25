data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                       = var.key_vault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tags                       = var.tags
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = var.soft_delete_retention_days
  rbac_authorization_enabled = var.rbac_authorization_enabled
  sku_name                   = var.sku_name

}

resource "azurerm_key_vault_access_policy" "container_app_policy" {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = azurerm_key_vault.keyvault.tenant_id
  object_id    = var.container_app_principal_id

  key_permissions = [
    "Get",
  ]

}

resource "azurerm_role_assignment" "sp_access" {
  principal_id         = var.sp_object_id
  role_definition_name = var.sp_role_definition_name
  scope                = azurerm_key_vault.keyvault.id
  depends_on           = [azurerm_key_vault.keyvault]
}

resource "azurerm_role_assignment" "containerapps_access" {
  principal_id         = var.container_app_principal_id
  role_definition_name = var.role_definition_name
  scope                = azurerm_key_vault.keyvault.id
  depends_on           = [azurerm_key_vault.keyvault]
}

resource "azurerm_key_vault_secret" "mongo-db-name" {
  name         = "mongo-db-name"
  value        = var.mongo_db_name
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on = [ azurerm_key_vault.keyvault]
 
}

resource "azurerm_key_vault_secret" "mongo_connstr" {
  name         = "mongo-connstr"
  value        = var.mongo_connection_string
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on = [ azurerm_key_vault.keyvault]
}

resource "azurerm_key_vault_secret" "weather_api_key" {
  name         = "weather-api-key"
  value        = var.weather_api_key
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on = [ azurerm_key_vault.keyvault]
}
