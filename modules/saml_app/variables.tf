variable "label" {}

variable "sso_acs_url" {}
variable "recipient" {}
variable "destination" {}
variable "audience" {}
variable "idp_issuer" {}

variable "subject_name_id_template" {}
variable "subject_name_id_format" {}

variable "response_signed" {
  type = bool
}

variable "assertion_signed" {
  type = bool
}

variable "signature_algorithm" {}
variable "digest_algorithm" {}

variable "honor_force_authn" {
  type = bool
}

variable "authn_context_class_ref" {}

variable "attribute_statements" {
  type = list(object({
    type         = string
    name         = string
    namespace    = string
    values       = optional(list(string))
    filter_type  = optional(string)
    filter_value = optional(string)
  }))
}
