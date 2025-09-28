# Variables for Managed Identity Module

variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the managed identities"
  type        = string
}

variable "container_registry_id" {
  description = "Resource ID of the container registry for ACR pull permissions"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the managed identities"
  type        = map(string)
  default     = {}
}