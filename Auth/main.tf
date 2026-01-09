# Lookup existing OAuth apps by label
#data "okta_app_oauth" "apps" {
#  for_each = toset(var.applications)
#  label    = each.value
#}

data "okta_app_oauth" "apps" {
  for_each = var.applications
  label    = each.key
}


# Create one Authorization Server per app
resource "okta_auth_server" "per_app" {
  for_each = data.okta_app_oauth.apps

  name        = "${each.key}-auth-server"
  description = "Authorization server for ${each.key}"

  # Required field – derived for now
  audiences = [
    "api://${each.key}"
  ]
}

resource "okta_auth_server_policy" "per_app" {
  for_each = okta_auth_server.per_app
  auth_server_id = each.value.id
  name           = var.applications[each.key].policy_name
  description    = "Access policy for ${each.key}"
  priority       = 1
  client_whitelist = ["ALL CLIENTS"]
}

locals {
  flattened_policy_rules = flatten([
    for app_name, app in var.applications : [
      for rule in app.rules : {
        app_name    = app_name
        rule_name   = rule.name
        grant_types = rule.grant_types
        scopes      = rule.scopes
      }
    ]
  ])
}

resource "okta_auth_server_policy_rule" "per_rule" {
  for_each = {
    for rule in local.flattened_policy_rules :
    "${rule.app_name}-${rule.rule_name}" => rule
  }

  auth_server_id = okta_auth_server.per_app[each.value.app_name].id
  policy_id      = okta_auth_server_policy.per_app[each.value.app_name].id

  name                 = each.value.rule_name
  priority             = 1
  status               = "ACTIVE"
  grant_type_whitelist = each.value.grant_types
  scope_whitelist      = each.value.scopes
}

