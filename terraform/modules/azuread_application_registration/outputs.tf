output "client_id" {
  description = "The Application (client) ID of the Azure AD Application"
  value       = azuread_application_registration.nodejs_demoapp.client_id
}