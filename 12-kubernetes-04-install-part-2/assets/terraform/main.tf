locals {
  # ssh_private_key_file = var.ssh_private_key_file != "" ? var.ssh_private_key_file : "${abspath(path.root)}/key"
  config = yamldecode(file(var.config))
  inventory = local.config.inventory.all
  params = local.config.params
  nodes = merge(flatten([
    [
      for group, members in try(local.inventory.children.k8s_cluster.children, {}): [
        {
          for node, params in members.hosts:
            node => {
                name = node,
                cpu = local.params[node].cpu
                memory = local.params[node].memory
                disk = local.params[node].disk
                public_ip = local.params[node].public_ip
            }
        }
      ]
    ],
    [
      for group, members in try(local.inventory.children, {}): [
        {
          for node, params in members.hosts:
            node => {
                name = node,
                cpu = local.params[node].cpu
                memory = local.params[node].memory
            }
        }
      ] if group != "k8s_cluster"
    ]
  ])...)
}

module virtualbox {
  count = local.params.provider == "virtualbox" ? 1 : 0
  nodes = local.nodes
  source = "./modules/virtualbox/"
  # image = "https://app.vagrantup.com/ubuntu/boxes/bionic64/versions/20180903.0.0/providers/virtualbox.box"
}

module ychosted {
  count = local.params.provider == "ychosted" ? 1 : 0
  nodes = local.nodes
  source = "./modules/ychosted/"
  # image = "https://app.vagrantup.com/ubuntu/boxes/bionic64/versions/20180903.0.0/providers/virtualbox.box"
}

locals {
  ssh_user = coalesce(try(module.virtualbox[0].ssh_user, null), try(module.ychosted[0].ssh_user, null))
  vm = coalesce(try(module.virtualbox[0].vm, null), try(module.ychosted[0].vm, null))
  nodes_ips = coalesce(try(module.virtualbox[0].worker_ips, null), try(module.ychosted[0].worker_public_ips, null))
}


module inventory {
  source = "./modules/ansible-inventory"
  ssh_user = local.ssh_user
  vm = local.vm
  inventory = local.inventory
}