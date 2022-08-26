output vm {
  value       = virtualbox_vm.node
  description = "created virtualbox"
}

output "worker_ips" {
  value = {for k, v in virtualbox_vm.node: k => v.network_adapter[0].ipv4_address}
}

output ssh_user {
  value       = var.ssh_user
  description = "ssh user"
}