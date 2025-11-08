data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = var.enabled_for_disk_encryption
  tags                        = var.tags
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = var.soft_delete_retention_days
  purge_protection_enabled    = var.purge_protection_enabled
  rbac_authorization_enabled  = var.rbac_authorization_enabled
  network_acls {
    default_action = var.default_action
    bypass         = var.bypass
  }

  sku_name = var.sku_name
}

resource "azurerm_role_assignment" "key_vault_access" {
  principal_id         = var.principal_id
  role_definition_name = var.role_definition_name
  scope                = azurerm_key_vault.keyvault.id
  depends_on           = [azurerm_key_vault.keyvault]
}

resource "azurerm_key_vault_secret" "grafana" {
  name         = var.key_vault_secret_grafana
  value        = var.grafana_admin_password
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on = [azurerm_key_vault.keyvault, azurerm_role_assignment.key_vault_access]
}