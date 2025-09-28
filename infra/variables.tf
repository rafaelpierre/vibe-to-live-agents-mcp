# Variables for the main Terraform configuration

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-vibe-to-live-agents"
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "East US"
}

variable "project_name" {
  description = "Name of the project used for resource naming"
  type        = string
  default     = "vibe-to-live-agents"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "openai_api_key" {
  description = "OpenAI API key for the application"
  type        = string
  sensitive   = true
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "vibe-to-live-agents"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}