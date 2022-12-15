resource "yandex_vpc_network" "network" {
  name = var.network_name
}

resource "yandex_vpc_subnet" "public" {
  name           = var.public_network.name
  v4_cidr_blocks = var.public_network.cidr_blocks
  network_id     = yandex_vpc_network.network.id
  description    = var.public_network.description
}
