data "aws_ami" "ubuntu" {
  most_recent      = true
  owners           = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server*"]
    # https://wiki.ubuntu.com/FocalFossa/ReleaseNotes
  }
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

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  count                  = local.instance_count[terraform.workspace]
  ami                    = data.aws_ami.ubuntu.id
  vpc_security_group_ids = ["default"]
  instance_type          = local.instance_type[terraform.workspace]

  tags = {
    Name = "netology"
    environment = terraform.workspace
  }
}