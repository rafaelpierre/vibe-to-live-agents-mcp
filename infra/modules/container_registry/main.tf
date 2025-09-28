# Azure Container Registry Module

resource "azurerm_container_registry" "main" {
  name                = replace("${var.project_name}acr", "-", "")
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled

  # Enable system-assigned managed identity
  identity {
    type = "SystemAssigned"
  }

  # Network access configuration
  public_network_access_enabled = var.public_network_access_enabled

  tags = var.tags
}

# Private endpoint for ACR (optional, for enhanced security)
resource "azurerm_private_endpoint" "acr" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "${var.project_name}-acr-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.project_name}-acr-psc"
    private_connection_resource_id = azurerm_container_registry.main.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  tags = var.tags
}