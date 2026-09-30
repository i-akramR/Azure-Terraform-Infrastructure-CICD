resource "azurerm_storage_account" "example" {
  for_each = var.SA

  name                     = each.value.storage_account_name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  identity {
    type = "UserAssigned"

    identity_ids = [
      var.cmk_identity_id
    ]
  }

  customer_managed_key {
    key_vault_key_id         = var.cmk_key_id
    user_assigned_identity_id = var.cmk_identity_id
  }

  sas_policy {
  expiration_period = "00.12:00:00"
  expiration_action = "Block"
}

  blob_properties {
    delete_retention_policy {
      days = 7
    }

    container_delete_retention_policy {
      days = 7
    }
  }
}