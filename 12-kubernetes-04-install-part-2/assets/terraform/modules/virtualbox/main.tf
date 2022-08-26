
resource "virtualbox_vm" "node" {
  for_each = var.nodes
  name      = each.value.name
  image     = var.image
  cpus      = each.value.cpu
  memory    = "${each.value.memory} mib"


  network_adapter {
    type           = "hostonly"
    host_interface = var.host_interface
  }
}

# module name {
#   source = "../ansible-inventory"
#   vm = virtualbox_vm.node
#   inventory = local.inventory
# }
