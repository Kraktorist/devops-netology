variable ssh_user {
  type = string
  default = "vagrant"
  description = "The user to connect to built machines"
}

# variable ssh_private_key_file {
#   type = string
#   default = "" # in case of empty value we use ./key file
#   description = "The SSH key to connect to built machines"
# }


variable ansible_inventory {
  type        = string
  default     = "../ansible/inventory.yml"
  description = "Ansible inventory file which will be outputed"
}

variable inventory {
  type        = map
  description = "Object of inventory"
}

variable vm {
  type        = map
  description = "List of virtual machines"
}

