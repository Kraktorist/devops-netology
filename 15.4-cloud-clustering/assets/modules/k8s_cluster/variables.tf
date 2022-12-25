variable cluster_name {
  type        = string
  description = "Kubernetes Cluster Name"
}

variable description {
  type        = string
  default     = ""
  description = "Kubernetes Cluster Description"
}

variable cluster_network_id {
  type        = string
  description = "Network ID for the cluster"
}

variable subnets {
    type = list(object({
        id = string
        zone = string
    })
  )
    description = "List of subnets where to place the cluster nodes"
}


variable cluster_version {
  type        = string
  default     = "1.22"
  description = "Kubernetes Cluster Version"
}

variable region {
  type        = string
  default     = "ru-central1"
  description = "Cluster Master Region"
}

variable public_ip {
    type = bool
    default = false
    description = "Enable Cluster Public IP Address"
}

variable cluster_sa_id {
  type        = string
  description = "Cluster Service Account ID"
}

variable node_sa_id {
  type        = string
  description = "Node Service Account ID"
}

variable kms_parameters {
  type        = object({
    default_algorithm = string
    rotation_period   = string
  })
  default = {
    default_algorithm = "AES_128"
    rotation_period   = "8760h"
  }
  description = "KMS Parameters"
}

variable labels {
  type        = list(object({
    key = string
    value = string
  }))
  default     = []
  description = "List of Labels for the Cluster"
}

variable release_channel {
  type        = string
  default     = "STABLE"
  description = "Kubernetes Release Channel"
}

variable network_policy_provider {
  type        = string
  default     = "CALICO"
  description = "Cluster Network Provider"
}

variable cluster_ipv4_range {
  type        = string
  default     = "10.0.0.0/8"
  description = "Kubernetes Subnet for Pods"
}



variable maintenance_policy {
    type = object({
        auto_upgrade = bool
        maintenance_windows = list(object({
            day = string
            start_time = string
            duration = string
        }))
    })
    default = {
        auto_upgrade = false
        maintenance_windows = []
    }
    description = "Cluster Maintenance Policy"
}