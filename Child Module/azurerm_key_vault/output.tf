output "key_vault_id" {
  description = "The resource ID of the Key Vault"
  value       = azurerm_key_vault.cmk.id
}

output "key_id" {
  description = "The resource ID of the customer managed key"
  value       = azurerm_key_vault_key.cmk.id
}