module "resource_group" {
  source = "../../Child Module/azurerm_resource_group"
  
  RGS = var.RGS
  }
module "storage_account" {
  source = "../../Child Module/azurerm_storage_account"

  SA = var.SA

  cmk_key_id      = module.key_vault.key_id
  cmk_identity_id = module.cmk_identity.identity_id

  depends_on = [
    module.resource_group,
    module.key_vault,
    module.cmk_identity
  ]
}
module "key_vault" {
  source = "../../Child Module/azurerm_key_vault"

  depends_on = [module.resource_group]
}
module "cmk_identity" {
  source = "../../Child Module/azurerm_cmk_identity"

  depends_on = [module.resource_group]
}