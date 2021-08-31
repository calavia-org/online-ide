output "client_key" {
  sensitive = true
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
  sensitive = true
}

output "host" {
  value = module.aks.host
}
