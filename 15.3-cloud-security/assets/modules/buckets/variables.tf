variable hosting_bucket {
  type        = string
  description = "bucket name for static website"
}

variable picture_path {
  type        = string
  description = "Picture to upload on hosting"
}

variable kms_master_key_id {
  type        = string
  description ="KMS Encryption Key ID"
}

variable certificate_id {
  type        = string
  description = "Certificate ID for HTTPS"
}