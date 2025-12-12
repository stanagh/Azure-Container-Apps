locals {

  prefix         = "infra"
  environment    = "prod"
  location       = "uksouth"
  location_short = "uks"
  domain_name    = "stanagh.website"
  region         = "uksouth"
  number         = "001"


  container_apps_name     = "ca-${local.location_short}-infra${random_integer.suffix.result}"
  fdendpoint_name         = "fdendpoint-${local.location_short}-infra-${random_integer.suffix.result}"
  container_revision_fqdn = module.container_apps.ca_latest_revision_fqdn


  rg_name = "${local.region}-rg-${local.environment}-${random_integer.suffix.result}"

  tags = {
    environment = local.environment
    location    = local.location
    managed_by  = "terraform"
    cost_center = "CC-12334"
    project     = "Project-AzureContainerApps"
    owner       = "Stanley"
    application = "AzureContainerApps"
    production  = "yes"
    environment_type = "production"

  }

}