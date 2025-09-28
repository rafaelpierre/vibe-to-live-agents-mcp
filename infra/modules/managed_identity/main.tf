# Azure Managed Identity Module

# Backend Managed Identity
resource "azurerm_user_assigned_identity" "backend" {
  name                = "${var.project_name}-backend-identity"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Frontend Managed Identity
resource "azurerm_user_assigned_identity" "frontend" {
  name                = "${var.project_name}-frontend-identity"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Role assignment for backend to pull from ACR
resource "azurerm_role_assignment" "backend_acr_pull" {
  scope                = var.container_registry_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.backend.principal_id
}

# Role assignment for frontend to pull from ACR
resource "azurerm_role_assignment" "frontend_acr_pull" {
  scope                = var.container_registry_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.frontend.principal_id
}