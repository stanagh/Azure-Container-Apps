variable "key_vault_name" {
  description = "The name of the Key Vault. Must be between 3 and 24 characters in length and use numbers and lower-case letters only."
  type        = string

}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Key Vault."
  type        = string
}

variable "location" {
  description = "The Azure region where the Key Vault will be created."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

# variable "tenant_id" {
#   description = "The Tenant ID that should be used for authenticating requests to the Key Vault."
#   type        = string
# }

variable "sku_name" {
  description = "The SKU name to use for this Key Vault. Possible values are 'standard' and 'premium'."
  type        = string
}

variable "soft_delete_retention_days" {
  description = "Specifies the number of days that deleted key vaults are retained. Value must be between 7 and 90 days."
  type        = number
}

variable "sp_object_id" {
  description = "The principal ID of the Service Principal that will be granted access to the Key Vault."
  type        = string
  
}

variable "sp_role_definition_name" {
  description = "The name of the role definition to assign to the service principal."
  type        = string
}

variable "role_definition_name" {
  description = "The name of the role definition to assign to the principal."
  type        = string
}

variable "rbac_authorization_enabled" {
  description = "Is RBAC Authorization enabled for this Key Vault? Defaults to true."
  type        = bool
}
variable "container_app_principal_id" {
  description = "The principal ID of the Container App's managed identity that will be granted access to the Key Vault."
  type        = string
}

variable "mongo_connection_string" {
  description = "The connection string for MongoDB"
  type        = string
  default     = ""
}

variable "weather_api_key" {
  description = "API key for the weather service"
  type        = string
  default     = ""
}

variable "mongo_db_name" {
  description = "The name of the MongoDB database"
  type        = string
  default     = ""
}
