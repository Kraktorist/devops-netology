resource "yandex_kubernetes_node_group" "ng" {
  cluster_id  = var.cluster_id
  name        = var.name
  description = var.description
  version     = var.cluster_version

  labels = {
    for label in var.labels: label.key => label.value
  }

  instance_template {
    platform_id = var.instance_template.platform_id

    resources {
      memory = var.instance_template.memory
      cores  = var.instance_template.cores
    }

    boot_disk {
      type = var.instance_template.boot_disk.type
      size = var.instance_template.boot_disk.size
    }

    scheduling_policy {
      preemptible = var.instance_template.scheduling_policy_preemptible
    }

    container_runtime {
      type = var.instance_template.container_runtime
    }
  }

  scale_policy {
    auto_scale {
      min = var.scale_policy.min
      initial = var.scale_policy.initial
      max = var.scale_policy.max
    }
  }


  allocation_policy {
    location {
        zone = var.subnet.zone
        subnet_id = var.subnet.id
    }
  }

  maintenance_policy {
    auto_upgrade = var.maintenance_policy.auto_upgrade
    auto_repair = var.maintenance_policy.auto_repair
    dynamic "maintenance_window" {
      for_each = var.maintenance_policy.maintenance_windows
      content {
        day        = maintenance_window.value["day"]
        start_time = maintenance_window.value["start_time"]
        duration   = maintenance_window.value["duration"]
      }
    }
  }
}