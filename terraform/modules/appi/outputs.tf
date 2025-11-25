output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.id
}

output "log_analytics_name" {
  description = "The name of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.name

}

output "instrumentation_key" {
  description = "The instrumentation key of the Application Insights resource"
  value       = azurerm_application_insights.application_insights.instrumentation_key
}

output "app_insights_connection_string" {
  description = "The connection string of the Application Insights resource"
  value       = azurerm_application_insights.application_insights.connection_string
  
}

output "app_id" {
  description = "The Application Insights app ID"
  value       = azurerm_application_insights.application_insights.app_id

}

output "sku_name" {
  description = "The SKU name of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.sku

}

output "logs_retention_in_days" {
  description = "The retention period (in days) for the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.retention_in_days
}

output "workspace_name" {
  description = "The name of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.name

}

output "workspace_location" {
  description = "The location of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.location

}