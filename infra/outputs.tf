# Output values from the main Terraform configuration

output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "container_registry_login_server" {
  description = "Login server URL for the container registry"
  value       = module.container_registry.registry_login_server
}

output "container_registry_name" {
  description = "Name of the container registry"
  value       = module.container_registry.registry_name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.key_vault.key_vault_uri
}

output "backend_app_url" {
  description = "URL of the backend container app"
  value       = "https://${module.backend_container_app.app_fqdn}"
}

output "frontend_app_url" {
  description = "URL of the frontend container app"
  value       = "https://${module.frontend_container_app.app_fqdn}"
}

output "backend_managed_identity_id" {
  description = "Resource ID of the backend managed identity"
  value       = module.managed_identity.backend_identity_id
}

output "frontend_managed_identity_id" {
  description = "Resource ID of the frontend managed identity"
  value       = module.managed_identity.frontend_identity_id
}