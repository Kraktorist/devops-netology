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

variable enable_encryption {
  type        = bool
  default     = true
  description = "Encrypt Bucket with KMS"
}

variable enable_https {
  type        = bool
  default     = true
  description = "Enable HTTPS for Bucket Site"
}

variable cert_domain_name {
  type        = string
  default     = "dn.qamo.ru"
  description = "Domain for Let's Encrypt Certificate"
}
