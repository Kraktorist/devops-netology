variable network_name {
  type        = string
  default     = "default"
  description = "VPC Network Name"
}

variable subnets {
  type = list(object({
    name        = string
    cidr_blocks = list(string)
    zone  = string
    description = string
  }))
  description = "List of Subnets"
}

