resource "azurerm_windows_web_app" "app" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = var.app_service_plan_id

  site_config {
    always_on = true
  }

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.insights.instrumentation_key
  }

  identity {
    type = "SystemAssigned"
  }
}

# Application Insights
resource "azurerm_application_insights" "insights" {
  name                = "${var.name}-AI"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
}





