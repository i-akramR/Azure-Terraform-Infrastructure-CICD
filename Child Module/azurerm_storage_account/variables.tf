variable "SA" {
  type = map(object({
    storage_account_name = string
    resource_group_name  = string
    location             = string
  }))
}

variable "cmk_key_id" {
  description = "Resource ID of the customer managed key"
  type        = string
}

variable "cmk_identity_id" {
  description = "Resource ID of the user assigned managed identity used for CMK"
  type        = string
}