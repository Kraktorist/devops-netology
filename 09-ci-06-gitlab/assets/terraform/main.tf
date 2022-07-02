provider "yandex" {
}

data "yandex_compute_image" "image" {
  family = "gitlab"
}

data "yandex_vpc_subnet" "subnet" {
  name = "dn-subnet"
}

locals {
  ssh_user = "ubuntu"
  ssh_pub_key = "~/.ssh/id_rsa.pub"
  ssh_private_key = "~/.ssh/id_rsa"
  inventory_path = "hosts.yml"
  git_password_file = "/etc/gitlab/initial_root_password"
}


resource "yandex_compute_instance" "node" {

  name = "ci-tutorial-gitlab"
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
      image_id = data.yandex_compute_image.image.id
    }
  }
  metadata = {
    type      = "ci-tutorial-gitlab"
    ssh-keys = "${local.ssh_user}:${file(local.ssh_pub_key)}"
  }
}

resource "null_resource" "gitlab_registry_configure" {
  depends_on = [
    yandex_compute_instance.node
  ]
  provisioner "local-exec" {
    command = "sleep 120 && ssh -ti ${local.ssh_private_key} ${local.ssh_user}@${yandex_compute_instance.node.network_interface[0].nat_ip_address} \"sudo sed -i '/registry_external_url/s/^#//g' /etc/gitlab/gitlab.rb && sudo gitlab-ctl reconfigure\""

  }
}

data "external" "password" {
  program = ["bash", "password.sh"]

  query = {
    host = yandex_compute_instance.node.network_interface[0].nat_ip_address
    user = local.ssh_user
    ssh_key_file = local.ssh_private_key
    gitlab_password_file = local.git_password_file
  }
}