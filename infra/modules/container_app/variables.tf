# Variables for Container App Module

variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
}

variable "app_name" {
  description = "Name of the application (backend/frontend)"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the container app"
  type        = string
}

variable "container_apps_environment_id" {
  description = "Resource ID of the container apps environment"
  type        = string
}

variable "container_image" {
  description = "Container image URL"
  type        = string
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 80
}

variable "managed_identity_id" {
  description = "Resource ID of the managed identity"
  type        = string
}

variable "revision_mode" {
  description = "Revision mode for the container app"
  type        = string
  default     = "Single"
  
  validation {
    condition     = contains(["Single", "Multiple"], var.revision_mode)
    error_message = "Revision mode must be Single or Multiple."
  }
}

variable "min_replicas" {
  description = "Minimum number of replicas"
  type        = number
  default     = 0
}

variable "max_replicas" {
  description = "Maximum number of replicas"
  type        = number
  default     = 10
}

variable "cpu_requests" {
  description = "CPU requests for the container"
  type        = string
  default     = "0.25"
}

variable "memory_requests" {
  description = "Memory requests for the container"
  type        = string
  default     = "0.5Gi"
}

variable "environment_variables" {
  description = "List of environment variables"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "secret_environment_variables" {
  description = "List of secret environment variables from Key Vault"
  type = list(object({
    name            = string
    secret_name     = string
    key_vault_uri   = string
  }))
  default = []
}

variable "external_enabled" {
  description = "Enable external ingress"
  type        = bool
  default     = true
}

variable "allow_insecure_connections" {
  description = "Allow insecure HTTP connections"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to the container app"
  type        = map(string)
  default     = {}
}