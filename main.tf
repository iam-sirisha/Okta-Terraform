module "oidc_apps" {
  source = "./modules/oidc_app"

  for_each = var.oidc_apps

  label                     = each.value.label
  application_type          = each.value.application_type
  grant_types               = each.value.grant_types
  response_types            = each.value.response_types

  redirect_uris = var.environment == "test" ? each.value.redirect_uris_prod: each.value.redirect_uris_test

  post_logout_redirect_uris = each.value.post_logout_redirect_uris
  consent_method            = each.value.consent_method
  issuer_mode               = each.value.issuer_mode
  refresh_token_rotation    = each.value.refresh_token_rotation
}
