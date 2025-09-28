# Outputs for Container App Module

output "app_id" {
  description = "Resource ID of the container app"
  value       = azurerm_container_app.main.id
}

output "app_name" {
  description = "Name of the container app"
  value       = azurerm_container_app.main.name
}

output "app_fqdn" {
  description = "Fully qualified domain name of the container app (root FQDN)"
  value       = azurerm_container_app.main.ingress[0].fqdn
}

output "app_url" {
  description = "URL of the container app (root URL)"
  value       = "https://${azurerm_container_app.main.ingress[0].fqdn}"
}