output "application_hostname" {
  value       = "https://${azurerm_spring_cloud_app.application.name}"
  description = "The Web application URL."
}
