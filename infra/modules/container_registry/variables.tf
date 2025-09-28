# Variables for Container Registry Module

variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the container registry"
  type        = string
}

variable "sku" {
  description = "SKU for the container registry"
  type        = string
  default     = "Standard"
  
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "SKU must be Basic, Standard, or Premium."
  }
}

variable "admin_enabled" {
  description = "Enable admin user for the container registry"
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Enable public network access to the container registry"
  type        = bool
  default     = true
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint for the container registry"
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for the private endpoint (required if enable_private_endpoint is true)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the container registry"
  type        = map(string)
  default     = {}
}