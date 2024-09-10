terraform {
  required_version = ">=1.3.0, < 4.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0, < 4.0.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "UniAnchietaTF"
    storage_account_name = "azuniachietatf"
    container_name       = "tfstate"
    key                  = "infranew3.tfstate"
  }
}

provider "azurerm" {
  features {}
}