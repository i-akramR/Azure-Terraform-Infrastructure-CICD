data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "cmk" {
  name                = "kv-catalyst-dev-cmk"
  location            = "Central India"
  resource_group_name = "rg-catalyst-dev"

  tenant_id = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  rbac_authorization_enabled = true

  soft_delete_retention_days = 7

  purge_protection_enabled = true

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"

    ip_rules = [
    "223.190.84.138"
  ]
  }
}

resource "azurerm_key_vault_key" "cmk" {
  name         = "key-catalyst-storage"
  key_vault_id = azurerm_key_vault.cmk.id
  key_type     = "RSA"
  key_size     = 2048

  expiration_date = "2027-09-28T00:00:00Z"

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"
  ]

  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }

    expire_after         = "P365D"
    notify_before_expiry = "P29D"
  }
}