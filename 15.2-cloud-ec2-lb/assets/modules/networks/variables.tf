variable network_name {
  type        = string
  description = "VPC Network Name"
}

variable public_network {
  type = object({
    name        = string
    cidr_blocks = list(string)
    description = string
  })
  description = "Public Network"
}
