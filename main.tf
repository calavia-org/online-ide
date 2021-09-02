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

data "azurerm_kubernetes_cluster" "credentials" {
  name                = module.aks.name
  resource_group_name = module.rg.name
  depends_on = [
    module.rg,
    module.aks
  ]
}
provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.credentials.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.cluster_ca_certificate)
  }
}
resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"
  namespace  = "default"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
}
