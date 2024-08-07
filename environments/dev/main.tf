terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.43.0"
    }
  }
}

# Configure the default provider
provider "azurerm" {
    features {}
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = "rg-lod"
}

# App Service Plan
module "asp" {
    source = "../../modules/azurerm/app_service_plan"

    name = "pusp-${var.student_number}"
    resource_group_name = data.azurerm_resource_group.rg.name
    location = data.azurerm_resource_group.rg.location
    sku_name = "S1"
}

# App Service
module "as" {
    source = "../../modules/azurerm/app_service"

    name = "pul-yaml-${var.student_number}"
    location = module.resource_group.location
    resource_group_name = module.resource_group.name
    app_service_plan_id = module.asp.id
}