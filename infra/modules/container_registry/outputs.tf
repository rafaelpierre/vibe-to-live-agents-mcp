# Outputs for Container Registry Module

output "registry_id" {
  description = "Resource ID of the container registry"
  value       = azurerm_container_registry.main.id
}

output "registry_name" {
  description = "Name of the container registry"
  value       = azurerm_container_registry.main.name
}

output "registry_login_server" {
  description = "Login server URL for the container registry"
  value       = azurerm_container_registry.main.login_server
}

output "registry_admin_username" {
  description = "Admin username for the container registry"
  value       = var.admin_enabled ? azurerm_container_registry.main.admin_username : null
  sensitive   = true
}

output "registry_admin_password" {
  description = "Admin password for the container registry"
  value       = var.admin_enabled ? azurerm_container_registry.main.admin_password : null
  sensitive   = true
}

output "registry_identity_principal_id" {
  description = "Principal ID of the container registry managed identity"
  value       = azurerm_container_registry.main.identity[0].principal_id
}