variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resource group"
  type        = string
}

variable "dns_zone_name" {
  description = "The name of the DNS zone"
  type        = string
}

variable "log_analytics_id" {
  description = "The ID of the Log Analytics Workspace"
  type        = string
}

variable "container_app_environment_name" {
  description = "The name of the Container App Environment"
  type        = string
}

variable "container_app_name" {
  description = "The name of the Container App"
  type        = string
}

variable "container_app_image" {
  description = "The container image for the Container App"
  type        = string
}

variable "custom_domain_name" {
  description = "The custom domain name for the Container App"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
}

variable "identity_type" {
  description = "The type of identity to assign to the Container App"
  type        = string
  default     = "UserAssigned"

}

variable "acr_login_server" {
  description = "The login server of the Azure Container Registry"
  type        = string
}

variable "acr_id" {
  description = "The ID of the Azure Container Registry"
  type        = string
}

variable "acr_admin_username" {
  description = "ACR admin username"
  type        = string
}

variable "acr_admin_password" {
  description = "ACR admin password"
  type        = string
  sensitive   = true
}

variable "custom_domain_subdomain" {
  description = "Subdomain for TXT verification"
  type        = string
}


variable "application_client_ID" {
  description = "The Client ID of the Entra application"
  type        = string
}

variable "app_insights_connection_string" {
  description = "The connection string for Application Insights"
  type        = string
}

variable "key_vault_name" {
  description = "The name of the Key Vault"
  type        = string
}