# Vibe-to-Live Agents - Azure Infrastructure

This Terraform configuration deploys the Vibe-to-Live Agents application to Azure using Container Apps.

## Architecture

The infrastructure includes:

- **Azure Container Registry (ACR)** - Stores container images for frontend and backend
- **Azure Key Vault** - Securely stores secrets like the OpenAI API key
- **Azure Container Apps Environment** - Provides the runtime environment for containers
- **Azure Container Apps** - Hosts the frontend and backend applications
- **Managed Identities** - Provides secure, identity-based access to Azure resources
- **Log Analytics Workspace** - Collects logs and metrics from Container Apps

## Prerequisites

1. **Azure CLI** installed and configured
2. **Terraform** (>= 1.0) installed
3. **Docker** for building and pushing images
4. **Azure subscription** with sufficient permissions

## Quick Start

### 1. Authentication

```bash
# Login to Azure
az login

# Set your subscription (optional)
az account set --subscription "your-subscription-id"
```

### 2. Configure Variables

```bash
# Copy the example variables file
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your values
# Especially set your OpenAI API key:
# openai_api_key = "sk-your-openai-key-here"
```

### 3. Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply
```

### 4. Build and Push Container Images

```bash
# Get ACR login server from Terraform output
ACR_LOGIN_SERVER=$(terraform output -raw container_registry_login_server)

# Login to ACR
az acr login --name $(terraform output -raw container_registry_name)

# Build and push backend image
cd ../backend
docker build -t $ACR_LOGIN_SERVER/vibe-backend:latest .
docker push $ACR_LOGIN_SERVER/vibe-backend:latest

# Build and push frontend image
cd ../frontend
docker build -t $ACR_LOGIN_SERVER/vibe-frontend:latest .
docker push $ACR_LOGIN_SERVER/vibe-frontend:latest
```

### 5. Access Your Applications

After deployment, get the application URLs:

```bash
# Frontend URL
terraform output frontend_app_url

# Backend URL
terraform output backend_app_url
```

## Module Structure

The infrastructure is organized into reusable modules:

- `modules/container_registry/` - Azure Container Registry
- `modules/key_vault/` - Azure Key Vault for secrets
- `modules/container_apps_environment/` - Container Apps environment
- `modules/managed_identity/` - User-assigned managed identities
- `modules/container_app/` - Individual container apps

## Environment Variables

The following environment variables are automatically configured:

### Backend Container App
- `ENVIRONMENT=production`
- `OPENAI_API_KEY` (from Key Vault)

### Frontend Container App
- `VITE_API_URL` (points to backend URL)

## Security Features

- **Managed Identities** - No stored credentials needed
- **Key Vault Integration** - Secrets are securely stored and accessed
- **ACR Integration** - Secure container image storage and access
- **HTTPS Only** - All ingress is HTTPS by default
- **Network Isolation** - Private networking options available

## Customization

### Scaling Configuration

Modify the container apps scaling in `main.tf`:

```hcl
module "backend_container_app" {
  # ... other configuration
  min_replicas = 1  # Always keep at least 1 instance
  max_replicas = 20 # Scale up to 20 instances
}
```

### Resource Requirements

Adjust CPU and memory in `main.tf`:

```hcl
module "backend_container_app" {
  # ... other configuration
  cpu_requests    = "1.0"    # 1 vCPU
  memory_requests = "2Gi"    # 2 GB RAM
}
```

## Cleanup

To destroy the infrastructure:

```bash
terraform destroy
```

## Troubleshooting

### Check Container App Logs

```bash
# Get container app logs
az containerapp logs show \\
  --name $(terraform output -raw backend_container_app_name) \\
  --resource-group $(terraform output -raw resource_group_name)
```

### Verify ACR Access

```bash
# Test ACR pull access
az acr repository list --name $(terraform output -raw container_registry_name)
```

### Key Vault Access Issues

```bash
# Check Key Vault access policies
az keyvault show --name $(terraform output -raw key_vault_name) | jq .properties.accessPolicies
```