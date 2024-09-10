resource "azurerm_resource_group" "main" {
  name     = "AzUnianchieta"
  location = "Brazil South"
}

resource "azurerm_container_registry" "main" {
  name                = "azunianchietaregistry"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Standard"
}

resource "azurerm_service_plan" "main" {
  name                = "az-unianchieta-plan"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_user_assigned_identity" "main" {
  name                = "webappacr"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_role_assignment" "main" {
  role_definition_name = "acrpull"
  scope                = azurerm_container_registry.main.id
  principal_id         = azurerm_user_assigned_identity.main.principal_id
  depends_on = [
    azurerm_user_assigned_identity.main
  ]
}

resource "azurerm_linux_web_app" "main" {
  name                                     = "azunianchieta-appservice"
  location                                 = azurerm_resource_group.main.location
  resource_group_name                      = azurerm_resource_group.main.name
  service_plan_id                          = azurerm_service_plan.main.id
  ftp_publish_basic_authentication_enabled = false

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.main.id]
  }

  site_config {
    always_on                                     = true
    container_registry_use_managed_identity       = true
    container_registry_managed_identity_client_id = azurerm_user_assigned_identity.main.client_id

    application_stack {
      docker_registry_url = "https://${azurerm_container_registry.main.login_server}"
      docker_image_name   = "product-service:latest"
    }
  }

  app_settings = {
    "WEBSITES_PORT"                       = "8080"
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  }
}
