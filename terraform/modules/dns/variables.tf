variable "resource_group_name" {
  description = "The name of the resource group in which to create the DNS zone."
  type        = string

}

variable "location" {
  description = "The Azure region where the DNS zone will be created."
  type        = string

}

variable "dns_zone_name" {
  description = "The name of the DNS zone (e.g., example.com)."
  type        = string

}

variable "cname_record_name" {
  description = "The name of the A record to create within the DNS zone."
  type        = string

}

variable "cname_record_value" {
  description = "The value of the CNAME record."
  type        = string

}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}

}

variable "ttl" {
  description = "The TTL (time to live) of the DNS A record in seconds."
  type        = number
  default     = 300
}

