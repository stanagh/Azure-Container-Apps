resource "azurerm_dns_txt_record" "fd_validation" {
  name                = join(".", ["_dnsauth", "app"])
  zone_name           = var.dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = 300

  record {
    value = azurerm_cdn_frontdoor_custom_domain.fdcustom_domain.validation_token
  }
}

resource "azurerm_dns_cname_record" "app" {
  name                = var.cname_record_name
  zone_name           = var.dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  record              = azurerm_cdn_frontdoor_endpoint.fdendpoint.host_name

  depends_on = [azurerm_cdn_frontdoor_route.fdroute]
}

resource "azurerm_cdn_frontdoor_profile" "fdProfile" {
  name                = var.fdprofile_name
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name

  response_timeout_seconds = 30
}

resource "azurerm_cdn_frontdoor_firewall_policy" "waf_policy" {
  name                = "${var.fdprofile_name}-wafpolicy"
  resource_group_name = var.resource_group_name
  sku_name            = azurerm_cdn_frontdoor_profile.fdProfile.sku_name
  mode                = "Prevention"

  managed_rule {
    type    = "Microsoft_DefaultRuleSet"
    version = "2.1"
    action  = "Block"
  }

  managed_rule {
    type    = "Microsoft_BotManagerRuleSet"
    version = "1.0"
    action  = "Block"
  }

  custom_rule {
    name                 = "rate-limit-rule"
    priority             = 1
    type                 = "RateLimitRule"
    rate_limit_threshold = 100
    action               = "Block"
    match_condition {
      match_variable = "RequestUri"
      operator       = "Contains"
      match_values   = ["/login", "/api/"]
    }
  }

  request_body_check_enabled        = true
  redirect_url                      = "https://learn.microsoft.com/docs/"
  custom_block_response_status_code = 403
  custom_block_response_body        = base64encode("Request blocked by WAF policy.")
}

resource "azurerm_cdn_frontdoor_security_policy" "waf_security_policy" {
  name                     = "${var.fdprofile_name}-wafsecuritypolicy"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fdProfile.id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.waf_policy.id

      association {
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_custom_domain.fdcustom_domain.id
        }
        patterns_to_match = ["/*"]
      }
    }
  }
}

resource "azurerm_cdn_frontdoor_origin_group" "fdorigin_group" {
  name                     = var.fdorigin_group_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fdProfile.id

  session_affinity_enabled = false

  health_probe {
    interval_in_seconds = 30
    path                = "/healthProbe"
    protocol            = "Https"
    request_type        = "HEAD"
  }

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
  origin_host_header = var.origin_host_name_header
  http_port          = 80
  https_port         = 443
  priority           = 1
  weight             = 1
}

resource "azurerm_cdn_frontdoor_endpoint" "fdendpoint" {
  name                     = var.fdendpoint_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fdProfile.id
  tags                     = var.tags

}

resource "azurerm_cdn_frontdoor_custom_domain" "fdcustom_domain" {
  name                     = replace(var.host_name, ".", "-")
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
  enabled                       = true

  forwarding_protocol    = "HttpsOnly"
  https_redirect_enabled = true
  patterns_to_match      = ["/*"]
  supported_protocols    = ["Http", "Https"]


  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.fdcustom_domain.id]
  link_to_default_domain          = false

  cache {
    query_string_caching_behavior = "IgnoreSpecifiedQueryStrings"
    query_strings                 = ["account", "settings"]
    compression_enabled           = false
    content_types_to_compress     = ["text/html", "text/javascript", "text/xml"]
  }

}

resource "azurerm_cdn_frontdoor_custom_domain_association" "fd_association" {
  cdn_frontdoor_custom_domain_id = azurerm_cdn_frontdoor_custom_domain.fdcustom_domain.id
  cdn_frontdoor_route_ids        = [azurerm_cdn_frontdoor_route.fdroute.id]
}