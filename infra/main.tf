# Main Terraform configuration
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Data source for current client configuration
data "azurerm_client_config" "current" {}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  
  tags = var.common_tags
}

# Container Registry Module
module "container_registry" {
  source = "./modules/container_registry"
  
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  project_name       = var.project_name
  
  tags = var.common_tags
}

# Build and Push Backend Image
module "backend_docker_build" {
  source = "./modules/docker_build_push"
  
  registry_name         = module.container_registry.registry_name
  registry_login_server = module.container_registry.registry_login_server
  registry_dependency   = module.container_registry.registry_id
  
  image_name      = "vibe-backend"
  build_context   = "../backend"
  dockerfile_path = "Dockerfile"
  
  build_args = {
    # Add any backend-specific build args here if needed
  }
}

# Key Vault Module (for secret variables)
module "key_vault" {
  source = "./modules/key_vault"
  
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  project_name       = var.project_name
  tenant_id          = data.azurerm_client_config.current.tenant_id
  
  # Grant access to managed identities
  managed_identity_principal_ids = [
    module.managed_identity.backend_identity_principal_id
  ]
  
  # Secrets to create
  secrets = {
    openai-api-key = var.openai_api_key
  }
  
  tags = var.common_tags
  
  # Ensure managed identities are created first
  depends_on = [module.managed_identity]
}

# Container Apps Environment Module
module "container_apps_environment" {
  source = "./modules/container_apps_environment"
  
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  project_name       = var.project_name
  
  tags = var.common_tags
}

# Managed Identity Module
module "managed_identity" {
  source = "./modules/managed_identity"
  
  resource_group_name   = azurerm_resource_group.main.name
  location             = azurerm_resource_group.main.location
  project_name         = var.project_name
  container_registry_id = module.container_registry.registry_id
  
  tags = var.common_tags
}

# Backend Container App Module
module "backend_container_app" {
  source = "./modules/container_app"
  
  resource_group_name           = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  project_name                 = var.project_name
  app_name                     = "backend"
  container_apps_environment_id = module.container_apps_environment.environment_id
  
  # Container configuration - use the built image with digest
  container_image = module.backend_docker_build.image_url
  container_port  = 8000
  
  # Environment variables
  environment_variables = [
    {
      name  = "ENVIRONMENT"
      value = "production"
    }
  ]
  
  # Secret environment variables (from Key Vault)
  secret_environment_variables = [
    {
      name            = "OPENAI_API_KEY"
      key_vault_uri   = module.key_vault.key_vault_uri
      secret_name     = "openai-api-key"
    }
  ]
  
  # Managed Identity
  managed_identity_id = module.managed_identity.backend_identity_id
  
  # Resource requirements
  cpu_requests    = "0.5"
  memory_requests = "1Gi"
  
  tags = var.common_tags
  
  # Ensure backend is built before deploying
  depends_on = [module.backend_docker_build]
}

# Build and Push Frontend Image (with backend URL)
module "frontend_docker_build" {
  source = "./modules/docker_build_push"
  
  registry_name         = module.container_registry.registry_name
  registry_login_server = module.container_registry.registry_login_server
  registry_dependency   = module.container_registry.registry_id
  
  image_name      = "vibe-frontend"
  build_context   = "../frontend"
  dockerfile_path = "Dockerfile"
  
  # Pass backend URL as build argument
  build_args = {
    VITE_API_URL = "https://${module.backend_container_app.app_fqdn}"
  }
  
  # Ensure backend is deployed first so we have the FQDN
  depends_on = [module.backend_container_app]
}

# Frontend Container App Module
module "frontend_container_app" {
  source = "./modules/container_app"
  
  resource_group_name           = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  project_name                 = var.project_name
  app_name                     = "frontend"
  container_apps_environment_id = module.container_apps_environment.environment_id
  
  # Container configuration - use the built image with digest
  container_image = module.frontend_docker_build.image_url
  container_port  = 80
  
  # Environment variables
  environment_variables = []
  
  # Secret environment variables (none for frontend)
  secret_environment_variables = []
  
  # Managed Identity
  managed_identity_id = module.managed_identity.frontend_identity_id
  
  # Resource requirements
  cpu_requests    = "0.25"
  memory_requests = "0.5Gi"
  
  tags = var.common_tags
  
  # Ensure frontend is built before deploying
  depends_on = [module.frontend_docker_build]
}