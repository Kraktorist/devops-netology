module kms {
  count = var.enable_encryption == true ? 1 : 0
  source = "./modules/kms"
}

module certificates {
  count = var.enable_https == true ? 1 : 0
  source = "./modules/certificates"
  cert_domain_name = var.cert_domain_name
}

module buckets {
  source = "./modules/buckets"
  hosting_bucket = var.hosting_bucket
  picture_path = var.picture_path
  kms_master_key_id = try(module.kms[0].kms_master_key_id, null)
  certificate_id = try(module.certificates[0].certificate_id, null)
}