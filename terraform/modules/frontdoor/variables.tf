variable "cname_record_name" {
  description = "The name of the A record to create within the DNS zone."
  type        = string

}

# variable "cname_record_value" {
#   description = "The value of the CNAME record."
#   type        = string
# }

variable "ttl" {
  description = "The TTL (time to live) of the DNS A record in seconds."
  type        = number
  default     = 300
}

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

variable "fdprofile_name" {
  description = "The name of the Front Door profile"
  type        = string
}

variable "sku_name" {
  description = "The SKU name for the Front Door profile"
  type        = string
  default     = "Standard_AzureFrontDoor"
}

variable "host_name" {
  description = "The host name for the Front Door custom domain"
  type        = string
}

# variable "frontdoor_custom_domain_name" {
#   description = "The name of the Front Door custom domain"
#   type        = string
# }

variable "fdendpoint_name" {
  description = "The name of the Front Door endpoint"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
}

variable "fdorigin_group_name" {
  description = "The name of the Front Door origin group"
  type        = string
}

variable "origin_name" {
  description = "The name of the Front Door origin"
  type        = string
}

# variable "fdendpoint_name" {
#     description = "The name of the Front Door endpoint"
#     type        = string    
# }

variable "fdroute_name" {
  description = "The name of the Front Door route"
  type        = string
}

variable "dns_zone_id" {
  description = "The ID of the DNS zone"
  type        = string
}

variable "origin_host_name" {
  description = "The host name of the origin server"
  type        = string
}
