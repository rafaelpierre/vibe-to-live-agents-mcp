# Azure Key Vault Module

# Data source for current client configuration
data "azurerm_client_config" "current" {}

# Key Vault
resource "azurerm_key_vault" "main" {
  name                = "kv${replace(var.project_name, "-", "")}${random_string.suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = var.sku_name

  # Enable soft delete and purge protection
  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = var.purge_protection_enabled

  # Network access rules
  public_network_access_enabled = var.public_network_access_enabled

  tags = var.tags
}

# Random string for unique Key Vault name (shorter for name constraints)
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Access policy for current user/service principal
resource "azurerm_key_vault_access_policy" "current_user" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = var.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Purge",
    "Recover"
  ]
}

# Access policies for managed identities (if provided)
resource "azurerm_key_vault_access_policy" "managed_identities" {
  for_each = toset(var.managed_identity_principal_ids)
  
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = var.tenant_id
  object_id    = each.value

  secret_permissions = [
    "Get"
  ]
}

# Create secrets
resource "azurerm_key_vault_secret" "secrets" {
  for_each = var.secrets

  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_key_vault_access_policy.current_user]

  tags = var.tags
}