terraform {
  backend "remote" {
    organization = "calavia-org"
    workspaces {
      name = "online-ide"
    }
  }
}

module "rg" {
  source  = "bcochofel/resource-group/azurerm"
  version = "1.4.1"

  name     = var.resource_group_name
  location = "North Europe"
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}