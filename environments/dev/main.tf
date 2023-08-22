terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.43.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.33.0"
    }
  }
}

# Configure the default provider
provider "azurerm" {
    features {}
}

provider "azuread" {}

data "azurerm_client_config" "current" {}

module "resource_group" {
    source = "../../modules/azurerm/resource_group"

    name   = "RG-IT-${var.environment_prefix}-${var.initials}"
    location = var.location

    owner = "QRM"
    department = "IT"
}

# App Service Plan
module "asp" {
    source = "../../modules/azurerm/app_service_plan"

    name = "ASP-IT-${var.environment_prefix}-${var.initials}"
    resource_group_name = module.resource_group.name
    location = module.resource_group.location
    sku_name = "S1"
}

# App Service
module "as" {
    source = "../../modules/azurerm/app_service"

    name = "AS-IT-${var.environment_prefix}-${var.initials}"
    location = module.resource_group.location
    resource_group_name = module.resource_group.name
    app_service_plan_id = module.asp.id
}

# App Service Deployment Slots
# Azure Monitor Diagnostic Settings
# Azure Log Analytics Workspace