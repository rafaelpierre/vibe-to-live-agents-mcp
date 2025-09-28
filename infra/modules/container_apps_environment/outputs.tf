# Outputs for Container Apps Environment Module

output "environment_id" {
  description = "Resource ID of the container apps environment"
  value       = azurerm_container_app_environment.main.id
}

output "environment_name" {
  description = "Name of the container apps environment"
  value       = azurerm_container_app_environment.main.name
}

output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.name
}