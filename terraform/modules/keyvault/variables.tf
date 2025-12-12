variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}


variable "location" {
  description = "The Azure region where the resources will be deployed"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
}

variable "key_vault_name" {
  description = "The name of the Key Vault"
  type        = string
}

variable "sku_name" {
  description = "The SKU name of the Key Vault"
  type        = string
}

variable "soft_delete_retention_days" {
  description = "The number of days to retain a deleted Key Vault"
  type        = number
  default     = 7
}

variable "rbac_authorization_enabled" {
  description = "Enable RBAC authorization for the Key Vault"
  type        = bool
  default     = true
}

variable "clientid_secret_writer_principal_id" {
  description = "The principal ID for the secret writer role assignment"
  type        = string
}

variable "secret_reader_principal_id" {
  description = "The principal ID for the secret reader role assignment"
  type        = string
}

# variable "mongo_connection_string" {
#   description = "The connection string for the MongoDB database"
#   type        = string
#   sensitive   = true
# }

# variable "mongo_db_name" {
#   description = "The name of the MongoDB database"
#   type        = string
# }

# variable "redis_host" {
#   description = "The host address for the Redis cache"
#   type        = string
#   sensitive   = true
# }

# variable "weather_api_key" {
#   description = "The API key for the weather service"
#   type        = string
#   sensitive   = true
# }

variable "kv_secrets" {
  description = "A mapping of secret names to be stored in Key Vault"
  type        = map(string)
  default = {
    mongo_connection_string = "mongo-connection-string"
    mongo_db_name           = "mongo-db-name"
    redis_host              = "redis-host"
    weather_api_key         = "weather-api-key"
  }
}