resource "yandex_mdb_mysql_cluster" "cluster" {
  name        = var.cluster_name
  environment = var.deployment_environment
  network_id  = var.cluster_network_id
  version     = "8.0"
  deletion_protection = var.deletion_protection

  resources {
    resource_preset_id = var.cluster_resources.resource_preset_id
    disk_type_id       = var.cluster_resources.disk_type_id
    disk_size          = var.cluster_resources.disk_size
  }

  maintenance_window {
    type = var.maintenance_window.type
    day  = var.maintenance_window.type == "WEEKLY" ? var.maintenance_window.day : null
    hour = var.maintenance_window.type == "WEEKLY" ? var.maintenance_window.hour : null
  }

  dynamic "backup_window_start" {
    for_each = var.backup_window_start != null ? [1] : []
    content {
      hours = var.backup_window_start.hours
      minutes = var.backup_window_start.minutes
    }
  }

  dynamic "host" {
    for_each = var.subnets
    content {
      zone = host.value["zone"]
      subnet_id =host.value["id"]
    }    
  }
}