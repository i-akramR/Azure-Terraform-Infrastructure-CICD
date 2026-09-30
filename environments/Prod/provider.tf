terraform {
  required_version = ">= 1.16.4, < 2.0.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.7.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-dev-infra"
    storage_account_name = "catalyst101958030"
    container_name       = "dev123"
    key                  = "dev123.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
