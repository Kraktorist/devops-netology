resource "yandex_mdb_mysql_database" "db" {
    cluster_id = var.cluster_id
    name       = var.database
}