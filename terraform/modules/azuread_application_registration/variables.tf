variable "azuread_app_name" {
  description = "The name of the Azure AD Application"
  type        = string

}

variable "sign_in_audience" {
  description = "The sign-in audience for the Azure AD Application"
  type        = string
  default     = "AzureADandPersonalMicrosoftAccounts"
}

variable "platform_type" {
  description = "The platform type for redirect URIs"
  type        = string
}

variable "public_client_enabled" {
  description = "Enable public client for the application"
  type        = bool
  default     = true
}