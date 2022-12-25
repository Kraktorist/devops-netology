resource "yandex_kms_symmetric_key" "key" {
  name              = "${var.cluster_name}-kms-key"
  description       = "${var.cluster_name} KMS Key"
  default_algorithm = var.kms_parameters.default_algorithm
  rotation_period   = var.kms_parameters.rotation_period
}

resource "yandex_kubernetes_cluster" "cluster" {
  name        = var.cluster_name
  description = var.description

  network_id = var.cluster_network_id

  master {
    regional {
      region = var.region

      dynamic "location" {
        for_each = var.subnets
        content {
          zone = location.value["zone"]
          subnet_id =location.value["id"]
        }    
      }
    }

    version   = var.cluster_version
    public_ip = var.public_ip

    maintenance_policy {
      auto_upgrade = var.maintenance_policy.auto_upgrade

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

  service_account_id      = var.cluster_sa_id
  node_service_account_id = var.node_sa_id
  kms_provider {
    key_id = yandex_kms_symmetric_key.key.id
  }

  labels = {
    for label in var.labels: label.key => label.value
  }

  release_channel = var.release_channel
}