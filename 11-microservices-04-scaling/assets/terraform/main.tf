terraform {
  required_providers {
    virtualbox = {
      source = "terra-farm/virtualbox"
      version = "0.2.2-alpha.1"
    }
  }
}

variable image {
  type        = string
  #default     = "https://app.vagrantup.com/ubuntu/boxes/bionic64/versions/20180903.0.0/providers/virtualbox.box"
  default     = "virtualbox.box"
  description = "OS image"
}
variable host_interface {
  type        = string
  description = "Host interface to map created virtual machines"
}
variable memory {
  type        = number
  default     = 2048
  description = "OS memory"
}
variable cpu {
  type        = number
  default     = 2
  description = "OS CPU"
}

resource "virtualbox_vm" "node" {
  for_each = toset(["redis01", "redis02", "redis03"])
  name      = each.value
  image     = var.image
  cpus      = var.cpu
  memory    = "${var.memory} mib"
  network_adapter {
    type           = "hostonly"
    host_interface = var.host_interface
  }
}

resource "local_file" "inventory" {
    filename = "../ansible/hosts.yaml"
    content     = <<-EOF
    all:
      hosts:
    %{ for instance in virtualbox_vm.node }
        ${instance.name}:
          ansible_host: ${instance.network_adapter.0.ipv4_address}
    %{ endfor }
      vars:
        ansible_user: vagrant
    EOF
}