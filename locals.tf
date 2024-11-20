locals {
  resource_name = "${var.project_name}-${var.environment}"
  rg_name = data.azurerm_app_configuration_key.rg_name.value
  rg_location = data.azurerm_app_configuration_key.rg_location.value
}