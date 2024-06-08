resource "azurerm_role_assignment" "Contributor" {
  scope                = azurerm_resource_group.default.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.default.principal_id
}