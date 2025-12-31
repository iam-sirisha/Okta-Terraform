saml_apps = {
  test_saml_app = {
    label       = "SAML APP1"

    sso_acs_url = "https://auth.workos.com/sso/saml/acs/2L6HIlXaS2xnQKsiIF2zBs4Af"
    recipient   = "https://auth.workos.com/sso/saml/acs/2L6HIlXaS2xnQKsiIF2zBs4Af"
    destination = "https://auth.workos.com/sso/saml/acs/2L6HIlXaS2xnQKsiIF2zBs4Af"
    audience    = "https://auth.gmail.com/2L6HIlXaS2xnQKsiIF2zBs4Af"
    idp_issuer  = "http://www.okta.com/$${org.externalKey}"

    subject_name_id_template = "$${user.userName}"
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
