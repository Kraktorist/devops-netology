resource "yandex_kubernetes_cluster" "k8s" {
  name        = "k8s"
  description = "k8s for 09-06 homework"

  network_id = data.yandex_vpc_network.network.id

  master {
    version = "1.21"
    zonal {
      zone      = data.yandex_vpc_subnet.subnet.zone
      subnet_id = data.yandex_vpc_subnet.subnet.id
    }

    public_ip = false

    # security_group_ids = ["${yandex_vpc_security_group.security_group_name.id}"]
  }

  service_account_id      = data.yandex_iam_service_account.service_account.id
  node_service_account_id = data.yandex_iam_service_account.service_account.id


  release_channel = "RAPID"
  network_policy_provider = "CALICO"

  # kms_provider {
  #   key_id = "${yandex_kms_symmetric_key.kms_key_resource_name.id}"
  # }
}

resource "yandex_kubernetes_node_group" "k8s" {
  cluster_id  = "${yandex_kubernetes_cluster.k8s.id}"
  name        = "k8s"
  description = "k8s for 09-06 homework"
  version     = "1.21"

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat                = true
      subnet_ids         = [data.yandex_vpc_subnet.subnet.id]
    }

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-b"
    }
  }
}
