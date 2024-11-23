locals {
  resource_name = "${var.project_name}-${var.environment}"
  rg_location = data.azurerm_resource_group.main.location
  rg_name= data.azurerm_resource_group.main.name
}