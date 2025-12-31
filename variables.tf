variable "okta_org_name" {
  description = "Okta organization name"
  default = "demo-automation-terraform-12601"
}

variable "okta_base_url" {
  description = "Okta base URL (okta.com or oktapreview.com)"
  default = "okta.com"
}

variable "okta_api_token" {
  description = "Okta API token"
  sensitive   = true
  default = "00SlxQTEoEgyjO10PTw9Ow9XDfnWZWlPbvsRiSEOVy"
}

# MAIN VARIABLE – controls N number of apps
variable "oidc_apps" {
  description = "Map of OIDC applications to deploy"
  type = map(object({
    label                     = string
    application_type          = string
    grant_types               = list(string)
    response_types            = list(string)
    redirect_uris_test        = list(string)
    redirect_uris_prod        = list(string)
    post_logout_redirect_uris = list(string)
    consent_method            = string
    issuer_mode               = string
    refresh_token_rotation    = string
  }))
}
############################
# SAML Apps
############################
variable "saml_apps" {
  description = "Map of SAML applications"
  type = map(object({
    label                    = string
    sso_acs_url              = string
    recipient                = string
    destination              = string
    audience                 = string
    idp_issuer               = string

    subject_name_id_template = string
    subject_name_id_format   = string

    response_signed          = bool
    assertion_signed         = bool

    signature_algorithm      = string
    digest_algorithm         = string

    honor_force_authn        = bool
    authn_context_class_ref  = string

    attribute_statements = list(object({
      type         = string
      name         = string
      namespace    = string
      values       = optional(list(string))
      filter_type  = optional(string)
      filter_value = optional(string)
    }))
  }))
}
