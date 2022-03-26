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
  security_groups = ["default"]
  tags = {
    Name = "netology"
  }
}
