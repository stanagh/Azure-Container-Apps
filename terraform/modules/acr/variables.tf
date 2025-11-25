variable "resource_group_name" {
  description = "The name of the resource group in which to create the Container Registry."
  type        = string
}

variable "location" {
  description = "The Azure region where the Container Registry will be created."
  type        = string
}

variable "acr_name" {
  description = "The name of the Container Registry. Must be between 5 and 50 characters in length and use numbers and lower-case letters only."
  type        = string
}

variable "sku" {
  description = "The SKU of the Container Registry. Valid options are 'Basic', 'Standard' and 'Premium'."
  type        = string
  default     = "Standard"
}

variable "admin_enabled" {
  description = "Specifies whether the admin user is enabled. Defaults to false."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

# variable "login_server" {
#   description = "The login server of the Container Registry"
#   type        = string
# }