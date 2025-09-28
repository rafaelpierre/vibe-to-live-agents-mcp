# Outputs for Managed Identity Module

output "backend_identity_id" {
  description = "Resource ID of the backend managed identity"
  value       = azurerm_user_assigned_identity.backend.id
}

output "backend_identity_principal_id" {
  description = "Principal ID of the backend managed identity"
  value       = azurerm_user_assigned_identity.backend.principal_id
}

output "backend_identity_client_id" {
  description = "Client ID of the backend managed identity"
  value       = azurerm_user_assigned_identity.backend.client_id
}

output "frontend_identity_id" {
  description = "Resource ID of the frontend managed identity"
  value       = azurerm_user_assigned_identity.frontend.id
}

output "frontend_identity_principal_id" {
  description = "Principal ID of the frontend managed identity"
  value       = azurerm_user_assigned_identity.frontend.principal_id
}

output "frontend_identity_client_id" {
  description = "Client ID of the frontend managed identity"
  value       = azurerm_user_assigned_identity.frontend.client_id
}