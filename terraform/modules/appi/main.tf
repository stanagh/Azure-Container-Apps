resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = var.workspace_name
  location            = var.workspace_location
  resource_group_name = var.resource_group_name
  sku                 = var.sku_name
  retention_in_days   = var.retention_in_days
  tags                = var.tags
}

resource "azurerm_application_insights" "application_insights" {
  name                = var.app_insights_name
  location            = var.workspace_location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.log_analytics.id
  application_type    = var.application_type
  tags                = var.tags
}