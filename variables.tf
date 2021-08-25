variable "default_pool_agent_count" {
    default = 0
}

#variable "ssh_public_key" {
#    default = "~/.ssh/id_rsa.pub"
#}

variable "dns_prefix" {
    default = "k8stest"
}

variable cluster_name {
    default = "online-ide"
}

variable resource_group_name {
    default = "calavia-org_online-ide"
}

variable location {
    default = "Central US"
}