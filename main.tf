terraform {
  backend "remote" {
    organization = "calavia-org"
    workspaces {
      name = "online-ide"
    }
  }
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

module "rg" {
  source  = "bcochofel/resource-group/azurerm"
  version = "1.4.1"
  #
  name     = var.resource_group_name
  location = var.location
}
module "aks" {
  source  = "bcochofel/aks/azurerm"
  version = "2.1.1"

  name                = var.cluster_name
  resource_group_name = module.rg.name
  default_pool_name   = "default"
  node_count          = 1
  dns_prefix          = var.dns_prefix

  node_pools = [
    {
      name                = "spot"
      priority            = "Spot"
      eviction_policy     = "Delete"
      spot_max_price      = 0.5 # note: this is the "maximum" price
      enable_auto_scaling = true
      node_count          = 1
      min_count           = 1
      max_count           = 5
      node_labels = {
        "kubernetes.azure.com/scalesetpriority" = "spot"
      }
      node_taints = [
        "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
      ]
      node_count = 1
    }
  ]

  depends_on = [module.rg]
}