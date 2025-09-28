# Variables for Key Vault Module

variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the key vault"
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "sku_name" {
  description = "SKU name for the key vault"
  type        = string
  default     = "standard"
  
  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "SKU name must be standard or premium."
  }
}

variable "soft_delete_retention_days" {
  description = "Number of days to retain soft-deleted keys"
  type        = number
  default     = 90
  
  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "Soft delete retention days must be between 7 and 90."
  }
}

variable "purge_protection_enabled" {
  description = "Enable purge protection for the key vault"
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Enable public network access to the key vault"
  type        = bool
  default     = true
}

variable "secrets" {
  description = "Map of secrets to create in the key vault"
  type        = map(string)
  default     = {}
  # Note: Individual secrets will be marked as sensitive in the resource
}

variable "tags" {
  description = "Tags to apply to the key vault"
  type        = map(string)
  default     = {}
}

variable "managed_identity_principal_ids" {
  description = "List of managed identity principal IDs that need access to Key Vault secrets"
  type        = list(string)
  default     = []
}