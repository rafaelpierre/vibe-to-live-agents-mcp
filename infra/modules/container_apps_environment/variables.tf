# Variables for Container Apps Environment Module

variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the container apps environment"
  type        = string
}

variable "log_analytics_sku" {
  description = "SKU for the Log Analytics workspace"
  type        = string
  default     = "PerGB2018"
}

variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 30
  
  validation {
    condition     = var.log_retention_days >= 30 && var.log_retention_days <= 730
    error_message = "Log retention days must be between 30 and 730."
  }
}

variable "tags" {
  description = "Tags to apply to the container apps environment resources"
  type        = map(string)
  default     = {}
}