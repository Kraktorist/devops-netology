variable cluster_id {
  type        = string
  description = "Kubernetes Cluster ID"
}

variable name {
  type        = string
  description = "Kubernetes Cluster Name"
}

variable description {
  type        = string
  default     = ""
  description = "Kubernetes Cluster Description"
}

variable cluster_version {
  type        = string
  default     = "1.22"
  description = "Kubernetes Cluster Version"
}

variable instance_template {
  type        = object({
    platform_id = string
    cores = number
    memory = number
    boot_disk = object({
        type = string
        size = number
    })
    container_runtime = string
    scheduling_policy_preemptible = bool
  })
  default     = {
    platform_id = "standard-v2"
    cores = 2
    memory = 2
    boot_disk = {
        type = "network-hdd"
        size = 64
    }
    container_runtime = "containerd"
    scheduling_policy_preemptible = false
  }
  description = "Instance Template"
}

variable scale_policy {
  type        = object({
    min     = number
    initial = number
    max     = number
  })
  description = "Auto Scale Policy"
}


variable subnet {
    type = object({
        id = string
        zone = string
    })
    description = "Subnet where to place the node group"
}

variable nat {
  type        = bool
  default     = true
  description = "Enables NAT for node group compute instances to access the internet"
}


variable labels {
  type        = list(object({
    key = string
    value = string
  }))
  default     = []
  description = "List of Labels for the Cluster"
}

variable maintenance_policy {
    type = object({
        auto_upgrade = bool
        auto_repair = bool
        maintenance_windows = list(object({
            day = string
            start_time = string
            duration = string
        }))
    })
    default = {
        auto_upgrade = false
        auto_repair = true
        maintenance_windows = []
    }
    description = "Nodes Maintenance Policy"
}