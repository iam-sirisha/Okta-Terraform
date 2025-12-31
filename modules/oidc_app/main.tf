resource "okta_app_oauth" "this" {
  label = var.label
  type  = var.application_type

  grant_types    = var.grant_types
  response_types = var.response_types

  redirect_uris             = var.redirect_uris
  post_logout_redirect_uris = var.post_logout_redirect_uris

  consent_method = var.consent_method
  issuer_mode    = var.issuer_mode

  refresh_token_rotation = var.refresh_token_rotation
}
