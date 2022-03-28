provider "yandex" {
}

# docker host
# https://cloud.yandex.ru/docs/cos/tutorials/coi-with-terraform

data "yandex_compute_image" "container-optimized-image" {
  family = "container-optimized-image"
}

data "yandex_vpc_subnet" "subnet" {
  name = "default-ru-central1-b" #default subnet
}

resource "yandex_compute_instance" "docker_host" {
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.container-optimized-image.id
    }
  }
  resources {
    cores = 2
    memory = 2
  }
  network_interface {
    subnet_id = data.yandex_vpc_subnet.subnet.subnet_id
    nat = true
  }
  metadata = {
    docker-container-declaration = file("${path.module}/declaration.yaml")
    user-data = file("${path.module}/cloud_config.yaml")
  }
}