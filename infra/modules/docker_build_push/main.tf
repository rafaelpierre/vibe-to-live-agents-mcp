# Docker Build and Push Module

terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

# Generate unique tag based on source hash
locals {
  # Use source hash for tag, or provided tag, or timestamp
  computed_tag = var.image_tag != "" ? var.image_tag : "latest"
  full_image_url = "${var.registry_login_server}/${var.image_name}:${local.computed_tag}"
}

# Get image digest after build and push
data "external" "image_digest" {
  program = ["bash", "-c", <<-EOT
    # Wait for the build to complete, then get the digest
    if [ -f /tmp/${var.image_name}_digest.txt ]; then
      DIGEST=$(cat /tmp/${var.image_name}_digest.txt)
      echo "{\"digest\": \"$DIGEST\"}"
    else
      echo "{\"digest\": \"\"}"
    fi
  EOT
  ]
  
  depends_on = [null_resource.docker_build_push]
}

# Login to Azure Container Registry
resource "null_resource" "acr_login" {
  triggers = {
    registry_name = var.registry_name
  }

  provisioner "local-exec" {
    command = "az acr login --name ${var.registry_name}"
  }

  depends_on = [var.registry_dependency]
}

# Build and push the Docker image
resource "null_resource" "docker_build_push" {
  triggers = {
    # Rebuild when source files change
    source_hash = var.source_hash != "" ? var.source_hash : data.external.source_hash.result.hash
    image_tag   = var.image_tag
    registry    = var.registry_login_server
    
    # Force rebuild when build args change
    build_args_hash = md5(jsonencode(var.build_args))
    
    # Force rebuild with correct platform
    platform_fix = "linux-amd64-v1"
  }

  provisioner "local-exec" {
    command = <<-EOT
      cd ${var.build_context}
      
      # Build the Docker image with build arguments for linux/amd64 platform
      docker build \
        --platform linux/amd64 \
        ${join(" ", [for key, value in var.build_args : "--build-arg ${key}='${value}'"])} \
        -t ${local.full_image_url} \
        -f ${var.dockerfile_path} \
        .
      
      # Push the image to ACR
      docker push ${local.full_image_url}
      
      # Get the digest and save it
      DIGEST=$(docker inspect --format='{{index .RepoDigests 0}}' ${local.full_image_url} | cut -d'@' -f2)
      echo "$DIGEST" > /tmp/${var.image_name}_digest.txt
    EOT
  }

  depends_on = [null_resource.acr_login]
}

# Generate content hash for source files to trigger rebuilds
data "external" "source_hash" {
  program = ["bash", "-c", <<-EOT
    cd ${var.build_context}
    # Create hash of all relevant source files
    find . -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" -o -name "*.py" -o -name "*.json" -o -name "Dockerfile" \) \
      -not -path "./node_modules/*" \
      -not -path "./.git/*" \
      -not -path "./dist/*" \
      -not -path "./__pycache__/*" \
      | sort | xargs md5sum | md5sum | cut -d' ' -f1 | jq -R '{hash: .}'
  EOT
  ]
}