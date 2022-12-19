output kms_master_key_id {
  value       = yandex_kms_symmetric_key.key.id
  description = "KMS Encryption Key ID"
}
