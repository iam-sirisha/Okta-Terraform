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
############################
# SAML Apps
############################
saml_apps = {
  chatgpt_saml_app = {
    label       = "chatGPT - SAML Integration"

    sso_acs_url = "https://auth.workos.com/sso/saml/acs/2L6HIlXaS2xnQKsiIF2zBs4Af"
    recipient   = "https://auth.workos.com/sso/saml/acs/2L6HIlXaS2xnQKsiIF2zBs4Af"
    destination = "https://auth.workos.com/sso/saml/acs/2L6HIlXaS2xnQKsiIF2zBs4Af"
    audience    = "https://auth.gmail.com/2L6HIlXaS2xnQKsiIF2zBs4Af"
    idp_issuer  = "http://www.okta.com/${org.externalKey}"

    subject_name_id_template = "${user.userName}"
    subject_name_id_format   = "urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified"

    response_signed         = true
    assertion_signed        = true
    signature_algorithm     = "RSA_SHA256"
    digest_algorithm        = "SHA256"

    honor_force_authn       = true
    authn_context_class_ref = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"

    attribute_statements = [
      {
        type      = "EXPRESSION"
        name      = "email"
        namespace = "urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified"
        values    = ["user.email"]
      },
      {
        type         = "GROUP"
        name         = "groupName"
        namespace    = "urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified"
        filter_type  = "STARTS_WITH"
        filter_value = "test"
      }
    ]
  }
}
