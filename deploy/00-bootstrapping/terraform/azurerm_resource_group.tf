resource "azurerm_resource_group" "default" {
    name = local.prefix
    location = "eastus"
}