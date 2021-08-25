provider "azurerm" {
    # The "feature" block is required for AzureRM provider 2.x. 
    # If you are using version 1.x, the "features" block is not allowed.
    version = "2.73.0"
    features {}
}

data "terraform_remote_state" "state" {
  backend = "remote"
  config = {
    organization = "calavia-org"
    workspaces = {
      name = "online-ide"
    }
  }
}