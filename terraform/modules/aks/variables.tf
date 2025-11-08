variable "resource_group_name" {
  description = "The name of the resource group in which to create the AKS cluster."
  type        = string
}

variable "location" {
  description = "The Azure region where the AKS cluster will be created."
  type        = string

}

variable "aks_cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "dns_prefix" {
  description = "The DNS prefix to use with the AKS cluster."
  type        = string
}

variable "node_count" {
  description = "The number of nodes in the default node pool."
  type        = number
  default     = 1
}

variable "node_vm_size" {
  description = "The size of the Virtual Machine to use for the nodes in the default node pool."
  type        = string
  default     = "Standard_B1s"

}

variable "identity_type" {
  description = "The type of identity used for the AKS cluster. Possible values are 'SystemAssigned', 'UserAssigned', and 'None'."
  type        = string
  default     = "SystemAssigned"

}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "role_based_access_control_enabled" {
  description = "Enable or disable Role-Based Access Control (RBAC) for the AKS cluster. Defaults to true."
  type        = bool

}








