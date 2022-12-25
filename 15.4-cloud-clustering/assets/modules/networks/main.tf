data "yandex_vpc_network" "network" {
  name = var.network_name
}

resource "yandex_vpc_subnet" "subnet" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }
  name           = each.value.name
  v4_cidr_blocks = each.value.cidr_blocks
  zone           = each.value.zone
  network_id     = data.yandex_vpc_network.network.id
  description    = each.value.description
}

