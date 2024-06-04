resource "azurerm_role_assignment" "Contributor" {
  scope                = azurerm_resource_group.default.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.default.object_id
}