variable cluster_name {
  type        = string
  default     = "mysql-cluster"
  description = "MySQL Cluster Name"
}

variable cluster_version {
  type        = string
  default     = "8.0"
  description = "MySQL Cluster Engine Version"
}


variable deployment_environment {
  type        = string
  default     = "PRESTABLE"
  description = "Deployment Environment"
}

variable deletion_protection {
  type        = bool
  default     = true
  description = "Protect cluster from accidental deletion"
}


variable cluster_network_id {
  type        = string
  description = "Netwokr ID for the cluster"
}

variable subnets {
    type = list(object({
        id = string
        zone = string
    })
  )
    description = "List of subnets where to place the cluster nodes"
}

variable cluster_resources {
  type        = object({
    resource_preset_id = string
    disk_type_id       = string
    disk_size          = number
  })
  default     = {
    "resource_preset_id" = "b1.medium"
    "disk_type_id"       = "network-ssd"
    "disk_size"          = 20
  }
  description = "Instance Resources Template"
}

variable maintenance_window {
  type        = object({
    type = string
    day  = string
    hour = number
  })
  default     = {
    "type"  = "ANYTIME"
    "day"   = null
    "hour"  = null
  }
  description = "Maintenance Windows"
}

variable backup_window_start {
  type        = object({
    minutes  = number
    hours = number
  })
  default = null
  description = "Backup Start Time"
}

