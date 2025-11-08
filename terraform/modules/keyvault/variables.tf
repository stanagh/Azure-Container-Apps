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

variable "tenant_id" {
  description = "The Tenant ID that should be used for authenticating requests to the Key Vault."
  type        = string
}

variable "sku_name" {
  description = "The SKU name to use for this Key Vault. Possible values are 'standard' and 'premium'."
  type        = string
}

variable "soft_delete_retention_days" {
  description = "Specifies the number of days that deleted key vaults are retained. Value must be between 7 and 90 days."
  type        = number
}

variable "purge_protection_enabled" {
  description = "Is Purge Protection enabled for this Key Vault? Defaults to false."
  type        = bool
  default     = true
}

variable "enabled_for_disk_encryption" {
  description = "Is disk encryption enabled for this Key Vault? Defaults to false."
  type        = bool
}

variable "bypass" {
  description = "Specifies which traffic can bypass the network rules. Possible values are 'AzureServices', 'None' and 'Logging'. Defaults to 'AzureServices'."
  type        = string
  default     = "AzureServices"

}

variable "default_action" {
  description = "Specifies the default action of allow or deny when no other rules match. Possible values are 'Allow' and 'Deny'"
  default     = "Allow"

}

variable "key_vault_secret_grafana" {
  description = "The name of the Key Vault secret to store the Grafana admin password."
  type        = string
  default     = "grafana-admin-password"
}


variable "grafana_admin_password" {
  description = "The Grafana admin password to store in Key Vault."
  type        = string
  default     = "random_password.grafana_admin.result"
}

# variable "role_definition_name" {
#   description = "The name of the role definition to assign to the principal."
#   type        = string
# }

variable "rbac_authorization_enabled" {
  description = "Is RBAC Authorization enabled for this Key Vault? Defaults to true."
  type        = bool
  default     = true
}

variable "role_definition_name" {
  description = "The name of the role definition to assign to the principal."
  type        = string
  default     = "Key Vault Secrets Officer"
}

variable "principal_id" {
  description = "The principal id of the service principal"
  type        = string
}