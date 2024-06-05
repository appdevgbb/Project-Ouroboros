resource "azurerm_storage_account" "backend" {
    name = "${local.prefix}backend"
    resource_group_name = azurerm_resource_group.default.name
    location = azurerm_resource_group.default.location
    account_tier = "Standard"
    account_replication_type = "LRS"
}

resource "azurerm_storage_container" "backend" {
    name = "infra"
    storage_account_name = azurerm_storage_account.backend.name
    container_access_type = "private"
}