variable network_name {
  type        = string
  description = "VPC Network Name"
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
