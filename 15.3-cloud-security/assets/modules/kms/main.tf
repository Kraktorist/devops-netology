# block for 15.3
resource "yandex_kms_symmetric_key" "key" {
  name              = "bucket-encryption-key"
  description       = "bucket-encryption key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" // equal to 1 year
}