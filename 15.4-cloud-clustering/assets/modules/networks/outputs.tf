output subnets {
  value       = [ for k, v in yandex_vpc_subnet.subnet : { "id" = v.id, "zone" = v.zone } ]
  description = "Subnet IDs"
}

output network_id {
  value       = yandex_vpc_network.network.id
  description = "Network ID"
}
