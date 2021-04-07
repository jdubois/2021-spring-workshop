
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

resource "azurerm_spring_cloud_app" "application" {
  name                = "spring-${var.application_name}-001"
  resource_group_name = var.resource_group
  service_name        = azurerm_spring_cloud_service.application.name

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_spring_cloud_java_deployment" "application" {
  name                = "deploy-${var.application_name}-001"
  spring_cloud_app_id = azurerm_spring_cloud_app.application.id
  cpu                 = 2
  instance_count      = 2
  jvm_options         = "-XX:+PrintGC"
  memory_in_gb        = 4
  runtime_version     = "Java_11"

  environment_variables = {
    # These are app specific environment variables
    "SPRING_PROFILES_ACTIVE"     = "prod,azure"

    "SPRING_DATA_MONGODB_DATABASE" = var.azure_cosmosdb_mongodb_database
    "SPRING_DATA_MONGODB_URI"      = var.azure_cosmosdb_mongodb_uri
  }
}
