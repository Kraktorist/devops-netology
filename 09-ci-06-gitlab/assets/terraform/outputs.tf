output "ya_private_ip" {
  value = yandex_compute_instance.node.network_interface[0].ip_address
}
output "ya_public_ips" {
  value = yandex_compute_instance.node.network_interface[0].nat_ip_address
}
output "password" {
  value = data.external.password.result.password
}
