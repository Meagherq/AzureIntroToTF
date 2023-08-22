resource "azurerm_resource_group" "rg" {
    name        = var.name
    location    = var.location

    tags = { Owner = var.owner, Dept = var.department }
}