output "external_ip" {
  value = yandex_compute_instance.docker_host.network_interface.0.nat_ip_address
}