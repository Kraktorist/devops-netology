locals {
  misc_hosts = tomap(
    {
      for group, members in try(var.inventory.children, {}):
          group => {
            "hosts" = {
                for node, params in members.hosts:
                    node => {
                    ansible_host = [
                        for v in var.vm:
                          try(v.network_adapter[0].ipv4_address, v.network_interface[0].nat_ip_address) if node == v.name
                    ][0]
                    }
            }
          } if group != "k8s_cluster"    
    }
  )
  ansible_inventory = {
    all = {
      vars = {
        ansible_user = var.ssh_user
        # ansible_ssh_private_key_file = local.ssh_private_key_file
      }
      hosts = {}
      children = merge(local.misc_hosts, {
        k8s_cluster = {
          children = tomap(
            {
              for group, members in try(var.inventory.children.k8s_cluster.children, {}):
                  group => {
                    hosts = {
                        for node, params in members.hosts:
                            node => {
                            ansible_host = [
                                for v in var.vm:
                                # TODO this needs to be fixed
                                try(v.network_adapter[0].ipv4_address, v.network_interface[0].nat_ip_address) if node == v.name
                            ][0]                
                            }
                    }
                  }
            }
          )
        }
      })
    }
  }
}

resource "local_file" "ansible_inventory" {
    filename = var.ansible_inventory
    content     = yamlencode(local.ansible_inventory)
}