resource "yandex_storage_bucket" "hosting" {
  bucket = var.hosting_bucket
  acl    = "public-read"

  website {
    index_document = "picture.png"
    error_document = "error.html"
  }

  # block for 15.3
  dynamic "server_side_encryption_configuration" {
    for_each = var.kms_master_key_id == null ? toset([]) : toset([1]) 
    content {
      rule {
        apply_server_side_encryption_by_default {
          kms_master_key_id = var.kms_master_key_id
          sse_algorithm     = "aws:kms"
        }
      }
    }
  }

  # block for 15.3
  dynamic "https" {
    for_each = var.certificate_id == null ? toset([]) : toset([1]) 
    content {
      certificate_id = var.certificate_id
    }
  }

}

resource "yandex_storage_object" "picture" {
  bucket = yandex_storage_bucket.hosting.id
  key    = "picture.png"
  source = var.picture_path
}