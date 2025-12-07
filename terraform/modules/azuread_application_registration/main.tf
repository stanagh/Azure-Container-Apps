data "azuread_application_published_app_ids" "well_known" {}
data "azuread_service_principal" "msgraph" {
      display_name = "Microsoft Graph"
}

resource "azuread_application_registration" "nodejs_demoapp" {
  display_name     = var.azuread_app_name
  description      = "My example application"
  sign_in_audience = var.sign_in_audience
} 

resource "azuread_application_api_access" "nodejs_demoapp_api_access" {
    application_id = azuread_application_registration.nodejs_demoapp.id
    api_client_id  = data.azuread_application_published_app_ids.well_known.result["MicrosoftGraph"]

  scope_ids = [
    data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["User.Read"],
  ]
}

resource "azuread_application_fallback_public_client" "example" {
  application_id = azuread_application_registration.nodejs_demoapp.id
  enabled        = true
}

resource "azuread_application_redirect_uris" "nodejs_demoapp_redirect_uris" {
  application_id = azuread_application_registration.nodejs_demoapp.id
  type                 = var.platform_type  
  redirect_uris = ["https://login.microsoftonline.com/common/oauth2/nativeclient",
   "https://login.live.com/oauth20_desktop.srf",
    "ms-appx-web://Microsoft.AAD.BrokerPlugin/00000000-1111-1111-1111-222222222222",
    "urn:ietf:wg:oauth:2.0:foo",
    "https://app.stanagh.website/signin",
   "http://localhost:3000/signin"
   ] 
}

