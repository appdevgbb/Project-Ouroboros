resource "azurerm_user_assigned_identity" "default" {
  location            = azurerm_resource_group.default.location
  name                = local.prefix
  resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_federated_identity_credential" "default" {
  name                = local.prefix
  resource_group_name = azurerm_resource_group.default.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  parent_id           = azurerm_user_assigned_identity.default.id
  subject             = "${local.subject}"
}