provider "yandex" {
}

resource "yandex_container_registry" "cregistry" {
  name      = "devops-netology-registry"
}

# pulling an image to the Yandex.Cloud registry

resource "null_resource" "image_uploader" {
  provisioner "local-exec" {
  command = <<EOT
    TOKEN=$(yc iam create-token --no-user-output)
    echo $TOKEN | docker login --username iam --password-stdin cr.yandex
    IMAGE="ghcr.io/runatlantis/atlantis"
    docker pull $IMAGE
    IMAGE_ID=`docker images | grep $IMAGE | awk {'print $3'}`
    docker tag $IMAGE_ID cr.yandex/${yandex_container_registry.cregistry.id}/atlantis
    docker push cr.yandex/${yandex_container_registry.cregistry.id}/atlantis
  EOT
  }
  depends_on = [ yandex_container_registry.cregistry ]
}

# docker host
# https://cloud.yandex.ru/docs/cos/tutorials/coi-with-terraform

data "yandex_compute_image" "container-optimized-image" {
  family = "container-optimized-image"
}

data "yandex_vpc_subnet" "subnet" {
  name = "default-ru-central1-b"
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
    subnet_id = data.subnet.subnet_id
    nat = true
  }
  metadata = {
    docker-container-declaration = file("${path.module}/declaration.yaml")
    user-data = file("${path.module}/cloud_config.yaml")
  }
}