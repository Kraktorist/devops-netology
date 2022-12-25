data "yandex_vpc_network" "network" {
  name = var.network_name
}

data "yandex_vpc_route_table" "this" {
  count = var.route_table_name != null ? 1 : 0
  name = var.route_table_name
}

resource "yandex_vpc_subnet" "subnet" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }
  name           = each.value.name
  v4_cidr_blocks = each.value.cidr_blocks
  zone           = each.value.zone
  network_id     = data.yandex_vpc_network.network.id
  description    = each.value.description
  route_table_id = var.route_table_name != null ? data.yandex_vpc_route_table.this[0].id : null
}

