data "yandex_compute_image" "os" {
  family = var.os_family
}

resource "yandex_vpc_network" "network" {
  name = var.network
}

resource "yandex_vpc_subnet" "subnet" {
  v4_cidr_blocks = [var.subnet]
  network_id     = yandex_vpc_network.network.id
}

resource "yandex_compute_instance" "node" {
  for_each = var.nodes
  name = each.value.name
  resources {
    cores  = each.value.cpu
    memory = each.value.memory/1024
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat = each.value.public_ip
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.os.id
      size = each.value.disk
    }
  }
  metadata = {
    type      = each.key
    ssh-keys = "${var.ssh_user}:${file(var.ssh_private_key_file)}"
  }
}
