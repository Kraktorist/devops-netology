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
    command = "sleep 120 && ssh -o StrictHostKeyChecking=no -ti ${local.ssh_private_key} ${local.ssh_user}@${yandex_compute_instance.node.network_interface[0].nat_ip_address} \"sudo sed -i '/registry_external_url/s/^#//g' /etc/gitlab/gitlab.rb && sudo gitlab-ctl reconfigure\""

  }
}

data "external" "password" {
  depends_on = [
    yandex_compute_instance.node
  ]
  program = ["bash", "password.sh"]

  query = {
    host = yandex_compute_instance.node.network_interface[0].nat_ip_address
    user = local.ssh_user
    ssh_key_file = local.ssh_private_key
    gitlab_password_file = local.git_password_file
  }
}