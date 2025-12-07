resource "azurerm_cdn_frontdoor_profile" "fdProfile" {
  name                = var.fdprofile_name
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name # e.g., "Standard_AzureFrontDoor"
}


resource "azurerm_cdn_frontdoor_origin_group" "fdorigin_group" {
  name                     = var.fdorigin_group_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fdProfile.id

  load_balancing {
    additional_latency_in_milliseconds = 0
    sample_size                        = 16
    successful_samples_required        = 3
  }
}

resource "azurerm_cdn_frontdoor_origin" "fdorigin" {
  name                          = var.origin_name
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fdorigin_group.id
  enabled                       = true

  certificate_name_check_enabled = false

  host_name          = var.origin_host_name
  origin_host_header = var.origin_host_name
  http_port          = 80
  https_port         = 443
  priority           = 1
  weight             = 1
  # to be filled as needed
}

resource "azurerm_cdn_frontdoor_endpoint" "fdendpoint" {
  name                     = var.fdendpoint_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fdProfile.id
  tags                     = var.tags
}

resource "azurerm_cdn_frontdoor_custom_domain" "fdcustom_domain" {
  name                     =  replace(var.host_name, ".", "-")
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fdProfile.id
  dns_zone_id              = var.dns_zone_id
  host_name                = var.host_name

  tls {
    certificate_type    = "ManagedCertificate"
    minimum_tls_version = "TLS12"
  }
}

resource "azurerm_cdn_frontdoor_route" "fdroute" {
  name                          = var.fdroute_name
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fdendpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fdorigin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.fdorigin.id]
  # cdn_frontdoor_rule_set_ids    = [azurerm_cdn_frontdoor_rule_set.fdrule_set.id]
  enabled = true

  forwarding_protocol    = "HttpsOnly"
  https_redirect_enabled = true
  patterns_to_match      = ["/*"]
  supported_protocols    = ["Http", "Https"]

  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.fdcustom_domain.id]
  link_to_default_domain          = false

  cache {
    query_string_caching_behavior = "IgnoreSpecifiedQueryStrings"
    query_strings                 = ["account", "settings"]
    compression_enabled           = true
    content_types_to_compress     = ["text/html", "text/javascript", "text/xml"]
  }
}

resource "azurerm_cdn_frontdoor_custom_domain_association" "fd_association" {
  cdn_frontdoor_custom_domain_id = azurerm_cdn_frontdoor_custom_domain.fdcustom_domain.id
  cdn_frontdoor_route_ids        = [azurerm_cdn_frontdoor_route.fdroute.id]
}