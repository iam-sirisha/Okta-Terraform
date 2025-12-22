variable "okta_org_name" {
  description = "Okta organization name"
}

variable "okta_base_url" {
  description = "Okta base URL (okta.com or oktapreview.com)"
}

variable "okta_api_token" {
  description = "Okta API token"
  sensitive   = true
}

variable "environment" {
  description = "Deployment environment: test or prod"
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
