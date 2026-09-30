variable "RGS" {
  type = map(object({
    resource_group_name = string
    location            = string
  }))
}

variable "SA" {
  type = map(object({
    storage_account_name = string
    resource_group_name  = string
    location             = string
  }))
}
