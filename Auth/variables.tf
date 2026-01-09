variable "okta_org_name" {
  description = "Okta organization name"
  default     = "automation-terraform-12601"
}

variable "okta_base_url" {
  description = "Okta base URL (okta.com or oktapreview.com)"
  default     = "okta.com"
}

variable "okta_api_token" {
  description = "Okta API token"
  sensitive   = true
  default     = "00SlxHUEoEgyjO10PTw9Ow9XDfnWZWlPbvsRiTEOVy"
}

#variable "applications" {
#  description = "List of existing OAuth application labels"
#  type        = list(string)
#}
variable "applications" {
  description = "OAuth applications with access policies and rules"
  type = map(object({
    policy_name = string
    rules = list(object({
      name        = string
      grant_types = list(string)
      scopes      = list(string)
    }))
  }))
}
