resource "azurerm_resource_group" "k8s" {
    name     = var.resource_group_name
    location = var.location
}

resource "azurerm_kubernetes_cluster" "k8s" {
    name                = var.cluster_name
    location            = azurerm_resource_group.k8s.location
    resource_group_name = azurerm_resource_group.k8s.name
    dns_prefix          = var.dns_prefix

#    linux_profile {
#        admin_username = "ubuntu"
#        ssh_key {
#            key_data = file(var.ssh_public_key)
#        }
#    }

    default_node_pool {
        name            = "default_pool"
        node_count      = var.default_pool_agent_count
        vm_size         = "Standard_D2_v2"
    }

    service_principal {
        client_id     = var.appId
        client_secret = var.password
    }

    network_profile {
        load_balancer_sku = "Standard"
        network_plugin = "kubenet"
    }

    tags = {
        Environment = "MustBePopulatedAtWorkspace"
    }
}