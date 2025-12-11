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

resource "azurerm_user_assigned_identity" "ca_uai" {
  name                = "${local.region}-uai-ca-${random_integer.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.tags
}

module "azuread_application_registration" {
  source                = "./modules/azuread_application_registration"
  azuread_app_name      = "nodejs_demoapp"
  sign_in_audience      = "AzureADandPersonalMicrosoftAccount"
  platform_type         = "PublicClient"
  public_client_enabled = true
}

module "acr" {
  source              = "./modules/acr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  acr_name            = "${local.region}acr${local.environment}${local.number}"
  sku                 = "Standard"
  admin_enabled       = false
  tags                = local.tags
}

resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_user_assigned_identity.ca_uai.principal_id
  role_definition_name = "AcrPull"
  scope                = module.acr.acr_id
}

module "app_insights" {
  source              = "./modules/appi"
  resource_group_name = azurerm_resource_group.rg.name
  app_insights_name   = "${local.region}-appi-${local.environment}-${random_integer.suffix.result}"
  application_type    = "web"
  workspace_name      = "${local.region}-log-${local.environment}-${random_integer.suffix.result}"
  workspace_location  = local.location
  sku_name            = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags
}

module "kv" {
  source              = "./modules/keyvault"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.tags

  key_vault_name             = "${local.region}-kv-${local.environment}${random_integer.suffix.result}"
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  rbac_authorization_enabled = true

  clientid_secret_writer_principal_id = data.azurerm_client_config.current.object_id
  secret_reader_principal_id          = azurerm_user_assigned_identity.ca_uai.principal_id

  # mongo_connection_string = var.TODO_MONGO_CONNSTR
  # mongo_connection_string = module.kv.mongo_connstr_secret_id
  # mongo_db_name           = var.TODO_MONGO_DB
  # redis_host              = var.REDIS_SESSION_HOST
  # weather_api_key         = var.WEATHER_API_KEY
}

module "container_apps" {
  source              = "./modules/ca"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.tags

  container_app_environment_name = "ca-env-${local.environment}${random_integer.suffix.result}"
  container_app_name             = "app-${local.environment}${random_integer.suffix.result}"
  container_app_image            = "${module.acr.login_server}/nodejs-app:v1.0"
  # container_app_image = "mcr.microsoft.com/azuredocs/aci-helloworld:latest" #placeholder image for testing

  acr_login_server = module.acr.login_server
  acr_id           = module.acr.acr_id
  uai_id           = azurerm_user_assigned_identity.ca_uai.id


  log_analytics_id  = module.app_insights.log_analytics_workspace_id
  identity_type     = "UserAssigned"
  user_assigned_ids = [azurerm_user_assigned_identity.ca_uai.id]

  key_vault_name = module.kv.key_vault_name

  # mongo_connection_string = module.kv.mongo_connstr_secret_id
  # mongo_connstr_secret_id = module.kv.mongo_connstr_secret_id
  # mongo_db_name           = module.kv.mongo_db_name_secret_id
  # weather_api_key         = module.kv.weather_api_key_secret_id
  # redis_connstr_secret_id = module.kv.redis_host_secret_id


  mongo_connstr_secret_id = module.kv.key_vault_secret_ids["mongo_connstr"]
  redis_connstr_secret_id    = module.kv.key_vault_secret_ids["redis_host"]
  weather_api_key_secret_id     = module.kv.key_vault_secret_ids["weather_api_key"]
  mongo_db_name_secret_id        = module.kv.key_vault_secret_ids["mongo_db_name"]

  application_insights_connection_string = module.app_insights.connection_string
  application_client_ID                  = module.azuread_application_registration.client_id
}

module "dns" {
  source              = "./modules/dns"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  dns_zone_name       = local.domain_name

  tags = local.tags
}

module "frontdoor" {
  source              = "./modules/frontdoor"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.tags

  dns_zone_id       = module.dns.dns_zone_id
  dns_zone_name     = module.dns.dns_zone_name
  cname_record_name = "app"
  # cname_record_value         = module.container_apps.ca_latest_revision_fqdn
  ttl = 300

  fdprofile_name      = "${local.region}-fd-${local.environment}-${random_integer.suffix.result}"
  fdendpoint_name     = "${local.region}-fde-${random_integer.suffix.result}"
  fdorigin_group_name = "${local.region}-fdog-${random_integer.suffix.result}"
  fdroute_name        = "${local.region}-fdr-${random_integer.suffix.result}"
  host_name           = "app.${local.domain_name}"

  origin_name      = "${local.region}-fdo-${random_integer.suffix.result}"
  origin_host_name = module.container_apps.container_app_hostname
  origin_host_name_header = module.container_apps.container_app_hostname

}
