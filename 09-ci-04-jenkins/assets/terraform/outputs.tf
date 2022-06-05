output "ya_private_ips" {
  value = {for k, v in yandex_compute_instance.node: k => v.network_interface[*].ip_address}
}
output "ya_public_ips" {
  value = {for k, v in yandex_compute_instance.node: k => v.network_interface[*].nat_ip_address}
}
