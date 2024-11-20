data "azurerm_app_configuration" "appconf" {
  name                = "app-configuration-100"
  resource_group_name = "existing-rg"
}

data "azurerm_app_configuration_key" "rg_name" {
  configuration_store_id = data.azurerm_app_configuration.appconf.id
  key                    = "${var.project_name}/${var.environment}/rg_name"
}

data "azurerm_app_configuration_key" "rg_location" {
  configuration_store_id = data.azurerm_app_configuration.appconf.id
  key                    = "${var.project_name}/${var.environment}/rg_location"
}