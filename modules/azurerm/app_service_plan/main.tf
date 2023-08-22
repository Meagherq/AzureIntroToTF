resource "azurerm_service_plan" "plan" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Windows"
  sku_name            = var.sku_name
}

resource "azurerm_monitor_autoscale_setting" "setting" {
  name                = "ASP-IT-AUTOSCALE"
  resource_group_name = azurerm_service_plan.plan.resource_group_name
  location            = azurerm_service_plan.plan.location
  target_resource_id  = azurerm_service_plan.plan.id

  profile {
    name = "defaultProfile"

    capacity {
      default = 1
      minimum = 1
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.plan.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
        metric_namespace   = "Microsoft.Web/serverfarms"
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.plan.id
        metric_namespace   = "Microsoft.Web/serverfarms"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}