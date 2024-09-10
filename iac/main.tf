resource "azurerm_resource_group" "main" {
  name     = "AzUnianchieta"
  location = "Brazil South"
}

resource "azurerm_service_plan" "main" {
  name                = "az-unianchieta-plan"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_web_app" "main" {
  name                                     = "azunianchieta-appservice"
  location                                 = azurerm_resource_group.main.location
  resource_group_name                      = azurerm_resource_group.main.name
  service_plan_id                          = azurerm_service_plan.main.id
  ftp_publish_basic_authentication_enabled = false

  site_config {
    application_stack {
      docker_registry_url = "https://ghcr.io"
      docker_image_name   = "reniciuspagotto/product-service:latest"
    }
  }

  app_settings = {
    "WEBSITES_PORT"                       = "8080"
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  }
}
