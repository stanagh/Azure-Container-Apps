variable "workspace_name" {
  description = "The name of the Log Analytics workspace"
  type        = string
}

variable "workspace_location" {
  description = "The location of the Log Analytics workspace"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "app_insights_name" {
  description = "The name of the Application Insights resource"
  type        = string
}

variable "application_type" {
  description = "The type of the application"
  type        = string
}

variable "sku_name" {
  description = "The SKU name for the Log Analytics workspace"
  type        = string
}

variable "retention_in_days" {
  description = "The retention period (in days) for the Log Analytics workspace"
  type        = number
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}