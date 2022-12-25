variable network_name {
  type        = string
  description = "VPC Network Name"
}

variable route_table_name {
  type        = string
  default     = null
  description = "Route Table Name"
}


variable subnets {
  type = list(object({
    name        = string
    cidr_blocks = list(string)
    zone  = string
    description = string
  }))
  description = "Public Network"
}
