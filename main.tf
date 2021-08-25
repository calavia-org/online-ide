terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.73.0"
    }
  }

  backend "remote" {
    organization = "calavia-org"
    workspaces = {
      name = "online-ide"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}