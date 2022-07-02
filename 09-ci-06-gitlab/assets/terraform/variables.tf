provider "yandex" {
}

data "yandex_compute_image" "image" {
  family = "gitlab"
}

data "yandex_vpc_network" "network" {
  name = "dn"
}

data "yandex_vpc_subnet" "subnet" {
  name = "dn-subnet"
}

data "yandex_iam_service_account" "service_account" {
  name = "terraform"
}

locals {
  ssh_user = "ubuntu"
  ssh_pub_key = "~/.ssh/id_rsa.pub"
  ssh_private_key = "~/.ssh/id_rsa"
  inventory_path = "hosts.yml"
  git_password_file = "/etc/gitlab/initial_root_password"
}
