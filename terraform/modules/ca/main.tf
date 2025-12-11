resource "azurerm_container_app_environment" "ca_env" {
  name                       = var.container_app_environment_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = var.log_analytics_id
  tags                       = var.tags
}

resource "azurerm_container_app" "ca" {
  name                         = var.container_app_name
  container_app_environment_id = azurerm_container_app_environment.ca_env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"
  tags                         = var.tags


  identity {
    type         = var.identity_type
    identity_ids = var.user_assigned_ids
  }


  registry {
    server   = var.acr_login_server
    identity = var.uai_id
  }

  secret {
    name                = "mongo-connstr"
    key_vault_secret_id = var.mongo_connstr_secret_id
    identity            = var.user_assigned_ids[0]
  }

  secret {
    name                = "mongo-db-name"
    key_vault_secret_id = var.mongo_db_name_secret_id
    identity            = var.user_assigned_ids[0]
  }

  secret {
    name                = "weather-api-key"
    key_vault_secret_id = var.weather_api_key_secret_id
    identity            = var.user_assigned_ids[0]
  }

  secret {
    name                = "redis-connstr"
    key_vault_secret_id = var.redis_connstr_secret_id
    identity            = var.user_assigned_ids[0]
  }

  template {
    min_replicas = 1
    max_replicas = 3
    container {
      name   = var.container_app_name
      image  = var.container_app_image
      cpu    = 0.25
      memory = "0.5Gi"
      
      env {
        name        = "TODO_MONGO_CONNSTR"
        secret_name = "mongo-connstr"
      }

      env {
        name        = "TODO_MONGO_DB"
        secret_name = "mongo-db-name"
      }

      env {
        name        = "WEATHER_API_KEY"
        secret_name = "weather-api-key"
      }

      env {
        name        = "REDIS_SESSION_HOST"
        secret_name = "redis-connstr"
      }

      env {
        name  = "APPLICATIONINSIGHTS_CONNECTION_STRING"
        value = var.application_insights_connection_string
      }

      env {
        name  = "ENTRA_APP_ID"
        value = var.application_client_ID
      }

      env {
        name  = "NODE_ENV"
        value = "production"
      }
    }
  }

  ingress {
    external_enabled           = true
    allow_insecure_connections = false
    target_port                = 3000
    transport                  = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}


