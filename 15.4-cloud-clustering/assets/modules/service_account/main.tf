data "yandex_resourcemanager_folder" "current" {
  name = var.folder_name
}

resource "yandex_iam_service_account" "sa" {
  name        = var.name
  description = var.description
}

resource "yandex_resourcemanager_folder_iam_binding" "binding" {
 folder_id = data.yandex_resourcemanager_folder.current.id
 role      = var.role
 members   = [
   "serviceAccount:${yandex_iam_service_account.sa.id}"
 ]
}