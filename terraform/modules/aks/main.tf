resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                              = var.aks_cluster_name
  location                          = var.location
  resource_group_name               = var.resource_group_name
  dns_prefix                        = var.dns_prefix
  tags                              = var.tags
  role_based_access_control_enabled = var.role_based_access_control_enabled

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.node_vm_size
  }

  identity {
    type = var.identity_type
  }
}