resource "random_password" "password" {
  length           = var.password_requirements.length
  special          = var.password_requirements.special
}

resource "yandex_mdb_mysql_user" "user" {
    cluster_id = var.cluster_id
    name       = var.username
    password   = random_password.password.result

    dynamic "permission" {
        for_each = var.roles
        # for_each = { for role in var.roles : role.database => role }
        content {
            database_name = permission.value["database"]
            roles = permission.value["roles"]
        }
    }

    authentication_plugin = var.authentication_plugin
}
