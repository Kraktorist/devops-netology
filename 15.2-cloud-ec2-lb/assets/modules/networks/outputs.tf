output subnet_id {
  value       = yandex_vpc_subnet.public.id
  description = "Subnet ID"
}

output network_id {
  value       = yandex_vpc_network.network.id
  description = "Network ID"
}
