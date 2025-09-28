# Variables for Docker Build and Push Module

variable "registry_name" {
  description = "Name of the Azure Container Registry"
  type        = string
}

variable "registry_login_server" {
  description = "Login server URL of the Azure Container Registry"
  type        = string
}

variable "registry_dependency" {
  description = "Resource dependency to ensure ACR is created first"
  type        = any
  default     = null
}

variable "image_name" {
  description = "Name of the Docker image"
  type        = string
}

variable "image_tag" {
  description = "Tag for the Docker image"
  type        = string
  default     = ""  # Will be auto-generated if not provided
}

variable "build_context" {
  description = "Path to the build context directory"
  type        = string
}

variable "dockerfile_path" {
  description = "Path to the Dockerfile relative to build context"
  type        = string
  default     = "Dockerfile"
}

variable "build_args" {
  description = "Build arguments to pass to Docker build"
  type        = map(string)
  default     = {}
}

variable "source_hash" {
  description = "Hash of source files to trigger rebuild (optional, will be auto-calculated if not provided)"
  type        = string
  default     = ""
}