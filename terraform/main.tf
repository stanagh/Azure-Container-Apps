data "azurerm_client_config" "current" {}

resource "random_integer" "suffix" {
  min = 1000
  max = 9999

}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = local.location
  tags     = local.tags
}

module "azuread_application_registration" {
  source                = "./modules/azuread_application_registration"
  azuread_app_name      = "nodejs_demoapp"
  sign_in_audience      = "AzureADandPersonalMicrosoftAccount"
  platform_type         = "PublicClient"
  public_client_enabled = true
}


module "storage" {
  source                   = "./modules/storage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  tags                     = local.tags
  min_tls_version          = "TLS1_2"
  storage_account_name     = "st${local.location_short}infra${random_integer.suffix.result}"
  account_replication_type = "LRS"
  account_tier             = "Standard"
}

module "kv" {
  source                     = "./modules/keyvault"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  tags                       = local.tags
  key_vault_name             = "kv-${local.location_short}-infra-${random_integer.suffix.result}"
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  rbac_authorization_enabled = true
  container_app_principal_id = module.container_apps.container_app_id_principal_id
  role_definition_name       = "Key Vault Secrets User"
  sp_object_id                  = data.azurerm_client_config.current.object_id
  sp_role_definition_name       = "Key Vault Secrets Officer"

}

module "dns" {
  source              = "./modules/dns"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.tags
  dns_name            = local.domain_name
  cname_record_name   = "app"
  cname_record_value  = local.container_revision_fqdn
  ttl                 = 300
}

module "acr" {
  source              = "./modules/acr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.tags
  acr_name            = local.acr_name
  sku                 = "Standard"
  admin_enabled       = true
}


module "app_insights" {
  source              = "./modules/appi"
  resource_group_name = azurerm_resource_group.rg.name
  app_insights_name   = "appi-${local.location_short}-infra-${random_integer.suffix.result}"
  application_type    = "web"
  workspace_name      = "law-${local.location_short}-infra-${random_integer.suffix.result}"
  workspace_location  = local.location
  sku_name            = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags
}

module "container_apps" {
  source                         = "./modules/ca"
  resource_group_name            = azurerm_resource_group.rg.name
  location                       = local.location
  tags                           = local.tags
  container_app_environment_name = "caenv-${local.location_short}-infra${random_integer.suffix.result}"
  container_app_name             = "ca-${local.location_short}-infra${random_integer.suffix.result}"
  container_app_image            = "${module.acr.login_server}/nodejs-app:v1"
  dns_zone_name                  = module.dns.dns_name
  log_analytics_id               = module.app_insights.log_analytics_workspace_id
  custom_domain_name             = "app.${local.domain_name}"
  identity_type                  = "SystemAssigned"
  acr_login_server               = module.acr.login_server
  acr_id                         = module.acr.acr_id
  acr_admin_username             = module.acr.admin_username
  acr_admin_password             = module.acr.admin_password
  key_vault_name                 = module.kv.key_vault_name
  custom_domain_subdomain        = "app"
  app_insights_connection_string = module.app_insights.app_insights_connection_string
  application_client_ID          = module.azuread_application_registration.client_id
}

module "frontdoor" {
  source                        = "./modules/frontdoor"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = local.location
  tags                          = local.tags
  dns_zone_name                 = module.dns.dns_zone_id
  cname_record_name             = "app"
  cname_record_value            = local.fdendpoint_name
  fdprofile_name                = "fdprofile-${local.location_short}-infra-${random_integer.suffix.result}"
  fdendpoint_name               = "fdendpoint-${local.location_short}-infra-${random_integer.suffix.result}"
  fdorigin_group_name           = "fdorigingroup-${local.location_short}-infra-${random_integer.suffix.result}"
  fdroute_name                  = "fdroute-${local.location_short}-infra-${random_integer.suffix.result}"
  frontodoor_custom_domain_name = "fdcustomdomain-${local.location_short}-infra-${random_integer.suffix.result}"
  host_name                     = "app.${local.domain_name}"
  origin_name                   = "containerapp-origin"
  depends_on                    = [module.container_apps, module.dns]
}



