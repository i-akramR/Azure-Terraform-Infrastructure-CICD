resource "azurerm_user_assigned_identity" "cmk" {
  name                = "id-catalyst-cmk"
  resource_group_name = "rg-catalyst-dev"
  location            = "Central India"
}