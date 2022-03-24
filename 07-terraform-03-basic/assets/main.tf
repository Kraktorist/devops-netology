provider "aws" {
}

locals {
  instance_type = {
    stage = "t2.micro"
    prod = "t2.micro"
  }

  instance_count = {
    stage = 1
    prod = 2
  }
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
  count = local.instance_count[terraform.workspace]
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = local.instance_type[terraform.workspace]
  security_groups = ["default"]
  tags = {
    Name = "netology"
    environment = terraform.workspace
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes = [tags]
  }
}

resource "aws_instance" "aws-ubuntu2" {
  for_each = toset([for o in range(0, local.instance_count[terraform.workspace]) : tostring(o+1)])
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = local.instance_type[terraform.workspace]
  security_groups = ["default"]
  tags = {
    Name = join("-",["netology", each.value])
    environment = terraform.workspace
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes = [tags]
  }
}
