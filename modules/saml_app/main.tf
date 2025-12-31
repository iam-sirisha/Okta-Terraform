resource "okta_app_saml" "this" {
  label = var.label

  sso_url     = var.sso_acs_url
  recipient   = var.recipient
  destination = var.destination
  audience    = var.audience
  idp_issuer  = var.idp_issuer

  subject_name_id_template = var.subject_name_id_template
  subject_name_id_format   = var.subject_name_id_format

  response_signed  = var.response_signed
  assertion_signed = var.assertion_signed

  signature_algorithm = var.signature_algorithm
  digest_algorithm    = var.digest_algorithm

  honor_force_authn       = var.honor_force_authn
  authn_context_class_ref = var.authn_context_class_ref

  dynamic "attribute_statements" {
    for_each = var.attribute_statements
    content {
      type      = attribute_statements.value.type
      name      = attribute_statements.value.name
      namespace = attribute_statements.value.namespace

      values = lookup(attribute_statements.value, "values", null)

      filter_type  = lookup(attribute_statements.value, "filter_type", null)
      filter_value = lookup(attribute_statements.value, "filter_value", null)
    }
  }
}
