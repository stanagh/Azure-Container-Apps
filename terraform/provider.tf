terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.49.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.7.0"

    }
  }
}


provider "azurerm" {
  subscription_id = var.subscription_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false # Set to true to prevent deletion of resource groups that contain resources
    }
  }
}

# provider "azuread" {
#   tenant_id = var.tenant_id
# }