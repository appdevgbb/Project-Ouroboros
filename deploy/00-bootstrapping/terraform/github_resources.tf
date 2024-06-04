data "github_repository" "default" {
    full_name = "${var.github_org_name}/${var.github_repo_name}"
}

resource "github_repository_environment" "default" {
    environment = var.entity_name
    repository = data.github_repository.default.name
}

resource "github_actions_environment_variable" "prefix" {
    repository = data.github_repository.default.name
    environment = github_repository_environment.default.environment
    variable_name = "TF_VAR_prefix"
    value = local.prefix
}

resource "github_actions_environment_secret" "tfprovider-client-id" {
    repository       = data.github_repository.default.name
    environment       = github_repository_environment.default.environment
    secret_name       = "ARM_CLIENT_ID"
    plaintext_value   = azuread_service_principal.default.client_id
}

# create the github secret for TF provider tenant id
resource "github_actions_environment_secret" "tfprovider-tenant-id" {
    repository = data.github_repository.default.name
    environment = github_repository_environment.default.environment
    secret_name = "ARM_TENANT_ID"
    plaintext_value = azuread_service_principal.default.application_tenant_id
}

# create the github secret for TF provider subscription id
resource "github_actions_environment_secret" "tfprovider-subscription-id" {
    repository = data.github_repository.default.name
    environment = github_repository_environment.default.environment
    secret_name = "ARM_SUBSCRIPTION_ID"
    plaintext_value = data.azurerm_client_config.current.subscription_id
}