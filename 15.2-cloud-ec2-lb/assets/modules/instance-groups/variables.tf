variable lamp {
  type        = map
  description = "LAMP Instance Configuration"
}

variable balancer {
  type        = string
  description = "Balancer type (alb or nlb)"
}

variable service_account_id {
  type        = string
  description = "Service Account For Instance Group Management"
}

variable subnet_id {
  type        = string
  description = "Subnet ID where to place the instances"
}

variable user_data {
  type        = string
  description = "cloud-init user-data file path"
}