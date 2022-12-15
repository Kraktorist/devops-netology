resource "yandex_storage_bucket" "hosting" {
  bucket = var.hosting_bucket
  acl    = "public-read"

  website {
    index_document = "picture.png"
    error_document = "error.html"
  }

}

resource "yandex_storage_object" "picture" {
  bucket = yandex_storage_bucket.hosting.id
  key    = "picture.png"
  source = var.picture_path
}