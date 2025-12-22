environment = "test"

okta_org_name  = "demo-automation-terraform-12601"
okta_base_url  = "okta.com"
okta_api_token = "00SlxQTEoEgyjO10PTw9Ow9XDfnWZWlPbvsRiSEOVy"

oidc_apps = {
  demo_web_app = {
    label                     = "Test-App1"
    application_type          = "web"
    grant_types               = ["authorization_code", "refresh_token"]
    response_types            = ["code"]
    redirect_uris_test        = ["https://test.example.com/callback"]
    redirect_uris_prod        = ["https://example.com/callback"]
    post_logout_redirect_uris = ["https://example.com"]
    consent_method            = "TRUSTED"
    issuer_mode               = "ORG_URL"
    refresh_token_rotation    = "STATIC"
  }

  reporting_app = {
    label                     = "Test-App2"
    application_type          = "web"
    grant_types               = ["authorization_code"]
    response_types            = ["code"]
    redirect_uris_test        = ["https://test.reporting.com/callback"]
    redirect_uris_prod        = ["https://reporting.com/callback"]
    post_logout_redirect_uris = ["https://reporting.com"]
    consent_method            = "REQUIRED"
    issuer_mode               = "DYNAMIC"
    refresh_token_rotation    = "ROTATE"
  }
}
