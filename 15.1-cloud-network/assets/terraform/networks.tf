resource "yandex_vpc_network" "network" {
  name = var.network_name
}

resource "yandex_vpc_subnet" "public" {
  name           = var.public_network.name
  v4_cidr_blocks = var.public_network.cidr_blocks
  network_id     = yandex_vpc_network.network.id
  description    = var.public_network.description
}

resource "yandex_vpc_subnet" "private" {
  name           = var.private_network.name
  v4_cidr_blocks = var.private_network.cidr_blocks
  network_id     = yandex_vpc_network.network.id
  description    = var.private_network.description
  route_table_id = yandex_vpc_route_table.rt.id
}

resource "yandex_vpc_route_table" "rt" {
  network_id = yandex_vpc_network.network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = var.nat_instance.ip
  }
}