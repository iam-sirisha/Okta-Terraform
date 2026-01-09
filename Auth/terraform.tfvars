#applications = [
#  "Test-App1",
#  "Test-App2",
#]

applications = {
  "Test-App1" = {
    policy_name = "Test-App1-access-policy"
    rules = [
      {
        name        = "Test-App1-client-credentials"
        grant_types = ["client_credentials"]
        scopes      = ["*"]
      }
    ]
  }

  "Test-App2" = {
    policy_name = "Test-App2-access-policy"
    rules = [
      {
        name        = "Test-App2-client-credentials"
        grant_types = ["client_credentials"]
        scopes      = ["*"]
      }
    ]
  }
}
