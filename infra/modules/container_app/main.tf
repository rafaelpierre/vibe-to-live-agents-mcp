# Azure Container App Module

resource "azurerm_container_app" "main" {
  name                         = "${var.project_name}-${var.app_name}"
  container_app_environment_id = var.container_apps_environment_id
  resource_group_name          = var.resource_group_name
  revision_mode               = var.revision_mode

  # Identity configuration
  identity {
    type         = "UserAssigned"
    identity_ids = [var.managed_identity_id]
  }

  # Registry configuration
  registry {
    server   = split("/", var.container_image)[0]
    identity = var.managed_identity_id
  }

  # Template configuration
  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    container {
      name   = var.app_name
      image  = var.container_image
      cpu    = var.cpu_requests
      memory = var.memory_requests

      # Environment variables
      dynamic "env" {
        for_each = var.environment_variables
        content {
          name  = env.value.name
          value = env.value.value
        }
      }

      # Secret environment variables
      dynamic "env" {
        for_each = var.secret_environment_variables
        content {
          name        = env.value.name
          secret_name = env.value.secret_name
        }
      }
    }
  }

  # Ingress configuration
  ingress {
    allow_insecure_connections = var.allow_insecure_connections
    external_enabled           = var.external_enabled
    target_port               = var.container_port
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  # Secrets (for secret environment variables)
  dynamic "secret" {
    for_each = var.secret_environment_variables
    content {
      name                = secret.value.secret_name
      key_vault_secret_id = "${secret.value.key_vault_uri}secrets/${secret.value.secret_name}"
      identity            = var.managed_identity_id
    }
  }

  tags = var.tags
}