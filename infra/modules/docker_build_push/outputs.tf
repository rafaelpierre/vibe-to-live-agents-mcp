# Outputs for Docker Build and Push Module

output "image_url" {
  description = "Full URL of the built and pushed Docker image (with digest if available)"
  value       = data.external.image_digest.result.digest != "" ? "${var.registry_login_server}/${var.image_name}@${data.external.image_digest.result.digest}" : local.full_image_url
}

output "image_url_with_tag" {
  description = "Image URL with tag (for reference)"
  value       = local.full_image_url
}

output "image_digest" {
  description = "Digest of the pushed image"
  value       = data.external.image_digest.result.digest
}

output "image_name" {
  description = "Name of the Docker image"
  value       = var.image_name
}

output "image_tag" {
  description = "Tag of the Docker image"
  value       = local.computed_tag
}

output "build_completed" {
  description = "Indicates that the build and push completed successfully"
  value       = true
  depends_on  = [null_resource.docker_build_push]
}