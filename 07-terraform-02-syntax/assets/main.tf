provider "aws" {
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_ami" "ubuntu" {
  most_recent      = true
  owners           = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server*"]
    # https://wiki.ubuntu.com/FocalFossa/ReleaseNotes
  }
}

resource "aws_instance" "aws-ubuntu" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  availability_zone = "eu-central-1b"
  private_ip = "172.31.33.63"
  security_groups = ["default"]
  tags = {
    Name = "netology"
  }
}

provider "yandex" {
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}

data "yandex_vpc_subnet" "subnet" {
  name = "dn-subnet"
}

resource "yandex_compute_instance" "ya-ubuntu" {

  zone = "ru-central1-a"
  resources {
    cores  = 2
    memory = 2
  }

  network_interface {
    subnet_id = "${data.yandex_vpc_subnet.subnet.id}"
    ip_address = "172.31.33.63"
  }

  boot_disk {
    initialize_params {
      image_id = "${data.yandex_compute_image.ubuntu.id}"
    }
  }

}