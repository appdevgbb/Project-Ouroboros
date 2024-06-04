
resource "azuread_service_principal" "msgraph" {
    client_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
    use_existing   = true
}

resource "azuread_application" "github-workload-identity" {
    display_name = "${local.prefix}-${var.entity_type}-${var.entity_name}"

    required_resource_access {
        resource_app_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph

        resource_access {
            id   = azuread_service_principal.msgraph.app_role_ids["User.Read.All"]
            type = "Role"
        }

        
        # resource_access {
        #     id   = azuread_service_principal.msgraph.oauth2_permission_scope_ids["User.ReadWrite"]
        #     type = "Scope"
        # }   
    }
}

resource "azuread_service_principal" "default" {
    client_id = azuread_application.github-workload-identity.client_id
}

resource "azuread_app_role_assignment" "github-workload-identity" {
    app_role_id         = azuread_service_principal.msgraph.app_role_ids["User.Read.All"]
    principal_object_id = azuread_service_principal.default.object_id
    resource_object_id  = azuread_service_principal.msgraph.object_id
}


resource "azuread_application_federated_identity_credential" "github-workload-identity" {
    application_id = azuread_application.github-workload-identity.id
    display_name   = "${local.prefix}-${var.entity_type}-${var.entity_name}"
    description    = "GH Workload Identity ${var.entity_type} ${var.entity_name}"
    audiences      = ["api://AzureADTokenExchange"]
    issuer         = "https://token.actions.githubusercontent.com"
    subject        = "${local.subject}"
}