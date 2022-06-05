provider "yandex" {
}

data "yandex_compute_image" "ubuntu" {
  family = "centos-7"
}

data "yandex_vpc_subnet" "subnet" {
  name = "dn-subnet"
}

locals {
  ssh_user = "centos"
  inventory_path = "../infrastructure/inventory/hosts.yml"
}


resource "yandex_compute_instance" "node" {
  for_each = {
    jenkins_masters = "jenkins-master-01",
    jenkins_agents = "jenkins-agent-01"
  }
  name = each.value
  resources {
    cores  = 2
    memory = 4
  }

  network_interface {
    subnet_id = data.yandex_vpc_subnet.subnet.id
    nat = true
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
    }
  }
  metadata = {
    type      = each.key
    ssh-keys = "${local.ssh_user}:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "local_file" "hosts" {
    filename = local.inventory_path
    content     = <<-EOF
    ---
    all:
      hosts: %{ for instance in yandex_compute_instance.node }
        ${instance.name}:
          ansible_host: ${instance.network_interface.0.nat_ip_address} %{ endfor }
      children: %{ for instance in yandex_compute_instance.node }
        ${instance.metadata.type}:
          hosts:
            ${instance.name}: %{ endfor }
      vars:
        ansible_connection_type: paramiko
        ansible_user: ${local.ssh_user}
    EOF
}
