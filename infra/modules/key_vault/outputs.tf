# Outputs for Key Vault Module

output "key_vault_id" {
  description = "Resource ID of the key vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "Name of the key vault"
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "URI of the key vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "secret_ids" {
  description = "Map of secret names to their resource IDs"
  value       = { for k, v in azurerm_key_vault_secret.secrets : k => v.id }
}