
resource "azurerm_application_insights" "application" {
  name                = "api-${var.application_name}-001"
  resource_group_name = var.resource_group
  location            = var.location
  application_type    = "web"
}

resource "azurerm_spring_cloud_service" "application" {
  name                = "sc-${var.application_name}-001"
  resource_group_name = var.resource_group
  location            = var.location
  sku_name            = "S0"

  tags = {
    "environment" = var.environment
  }

  config_server_git_setting {
    uri          = "https://github.com/Azure-Samples/spring-cloud-sample-public-config.git"
  }

  trace {
    instrumentation_key = azurerm_application_insights.application.instrumentation_key
    sample_rate         = 10.0
  }
}
