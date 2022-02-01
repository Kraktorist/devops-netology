variable "token" {
  sensitive = true
  type = string
}

variable "folder_id" {
  sensitive = false
  type = string
}

variable "subnet_id" {
  sensitive = false
  type = string
}

variable "zone" {
  sensitive = false
  type = string
}

source "yandex" "vm" {
  disk_type           = "network-nvme"
  folder_id           = var.folder_id
  image_description   = "by packer"
  image_family        = "centos"
  image_name          = "centos-7-base"
  source_image_family = "centos-7"
  ssh_username        = "centos"
  subnet_id           = var.subnet_id
  token               = var.token
  use_ipv4_nat        = true
  zone                = var.zone
}

build {
  sources = ["source.yandex.vm"]

  provisioner "shell" {
    inline = ["sudo yum -y update", "sudo yum -y install bridge-utils bind-utils iptables curl net-tools tcpdump rsync telnet openssh-server"]
  }

}
