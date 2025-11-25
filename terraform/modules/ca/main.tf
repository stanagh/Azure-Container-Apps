#modules/ca/main.tf
resource "azurerm_dns_txt_record" "dns_txt_record" {
  name                = "asuid.${var.custom_domain_subdomain}"
  resource_group_name = var.resource_group_name
  zone_name           = var.dns_zone_name
  ttl                 = 300

  record {
    value = azurerm_container_app.container_app.custom_domain_verification_id
  }
}


resource "azurerm_container_app_environment" "container_app_environment" {
  name                       = var.container_app_environment_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = var.log_analytics_id
  tags                       = var.tags
}



resource "azurerm_container_app" "container_app" {
  name                         = var.container_app_name
  container_app_environment_id = azurerm_container_app_environment.container_app_environment.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"
  tags                         = var.tags

  identity {
    type = var.identity_type
  }

  secret {
    name  = "acr-password"
    value = var.acr_admin_password
  }

  secret {
    name = "mongo-connstr"
    value = "https://${var.key_vault_name}.vault.azure.net/secrets/mongo-connstr"
  }

  secret {
    name = "mongo-db-name"
    value = "https://${var.key_vault_name}.vault.azure.net/secrets/mongo-db-name"
  }

  secret {
    name = "weather-api-key"
    value = "https://${var.key_vault_name}.vault.azure.net/secrets/weather-api-key"
  }

  secret {
    name  = "appinsights-connstr"
    value = var.app_insights_connection_string
  }

  secret {
    name  = "entra-app-id"
    value = var.application_client_ID
  }

  registry {
    server               = var.acr_login_server
    username             = var.acr_admin_username
    password_secret_name = "acr-password"

  }

  template {
    container {
      name   = var.container_app_name
      image  = var.container_app_image
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name        = "NODE_ENV"
        value       = "production"
      }

      env {
        name        = "TODO_MONGO_CONNSTR"
        secret_name = "mongo-connstr"
      }

      env {
        name        = "TODO_MONGO_DB"
        secret_name = "mongo-db-name"
      }

      env {
        name        = "APPLICATIONINSIGHTS_CONNECTION_STRING"
        secret_name = "appinsights-connstr"
      }

      env {
        name        = "ENTRA_APP_ID"
        secret_name = "entra-app-id"
      }

      env {
        name        = "WEATHER_API_KEY"
        secret_name = "weather-api-key"
      }
    }
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 3000
    transport                  = "http"
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_container_app.container_app.identity[0].principal_id
  role_definition_name = "AcrPull"
  scope                = var.acr_id
}




