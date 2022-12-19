variable hosting_bucket {
  type        = string
  default     = "dn.qamo.ru"
  description = "bucket name for static website"
}

variable picture_path {
  type        = string
  default     = "pictures/index.png"
  description = "Picture to upload on hosting"
}

variable network_name {
  type        = string
  default     = "default"
  description = "VPC Network Name"
}

variable public_network {
  type = object({
    name        = string
    cidr_blocks = list(string)
    description = string
  })

  default     = {
    "name" = "public"
    "cidr_blocks" = ["192.168.10.0/24"]
    "description" = "public network"
  }
  description = "Public Network"
}

variable lamp {
  type        = map
  default     = {
    "image_id" = "fd827b91d99psvq5fjit"
    "cpu" = 2
    "memory" = 2
  }
  description = "LAMP Instance Configuration"
}

variable service_account_id {
  type        = string
  default     = "ajepoevbqkkfp01tuq4m"
  description = "LAMP Instance Group Service Account"
}

variable user_data {
  type        = string
  default     = "userdata.yml"
  description = "cloud-init user-data file path"
}

variable balancer {
  type        = string
  default     = "alb"
  description = "Balancer type (alb or nlb)"
}
