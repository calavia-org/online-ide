output "client_key" {
  value = module.aks.client_key
}

output "client_certificate" {
  value = module.aks.client_certificate
}

output "cluster_ca_certificate" {
  value = module.aks.cluster_ca_certificate
}

output "cluster_username" {
  value = module.aks.username
}

output "cluster_password" {
  value = module.aks.password
}

output "host" {
  value = module.aks.host
}
