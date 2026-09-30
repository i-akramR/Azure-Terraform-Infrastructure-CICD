output "principal_id" {
  description = "The principal ID of the CMK managed identity"
  value       = azurerm_user_assigned_identity.cmk.principal_id
}

output "identity_id" {
  description = "The resource ID of the CMK managed identity"
  value       = azurerm_user_assigned_identity.cmk.id
}