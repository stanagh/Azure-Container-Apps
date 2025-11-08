variable "resource_group_name" {
  description = "The name of the resource group in which to create the DNS zone."
  type        = string

}

variable "location" {
  description = "The Azure region where the DNS zone will be created."
  type        = string

}

variable "dns_name" {
  description = "The name of the DNS zone (e.g., example.com)."
  type        = string

}

variable "a_record_name" {
  description = "The name of the A record to create within the DNS zone."
  type        = string

}

variable "allocation_method" {
  description = "The allocation method for the public IP address. Valid options are 'Static' and 'Dynamic'."
  type        = string
  default     = "Static"

}

variable "public_ip_sku" {
  description = "The SKU of the public IP address. Valid options are 'Basic' and 'Standard'."
  type        = string
  default     = "Standard"

}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}

}


variable "public_ip_name" {
  description = "The name of the public IP address resource."
  type        = string

}

variable "ttl" {
  description = "The TTL (time to live) of the DNS A record in seconds."
  type        = number
  default     = 300
}

variable "records" {
  description = "A list of IP addresses for the A record."
  type        = list(string)
  default     = ["10.0.180.17"]

}