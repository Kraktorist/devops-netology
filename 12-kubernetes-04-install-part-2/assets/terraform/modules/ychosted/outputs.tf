output vm {
  value       = yandex_compute_instance.node
  description = "created instances"
}
output "worker_private_ips" {
  value = {for k, v in yandex_compute_instance.node: k => v.network_interface[0].ip_address}
}
output "worker_public_ips" {
  value = {for k, v in yandex_compute_instance.node: k => v.network_interface[0].nat_ip_address}
}

output ssh_user {
  value       = var.ssh_user
  description = "ssh user"
}
