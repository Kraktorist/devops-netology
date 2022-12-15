data "yandex_iam_service_account" "lamp" {
  service_account_id = var.service_account_id
}

resource "yandex_compute_instance_group" "nlb_lamp_group" {
  name                = "nlb-lamp-ig"
  service_account_id = data.yandex_iam_service_account.lamp.id
  deletion_protection = false
  instance_template {
    platform_id = "standard-v1"
    resources {
      cores  = var.lamp.cpu
      memory = var.lamp.memory
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = var.lamp.image_id
      }
    }
    network_interface {
      subnet_ids = [yandex_vpc_subnet.public.id]
      nat = true
    }

    metadata = {
      user-data = file(var.user_data)
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-b"]
  }

  deploy_policy {
    max_unavailable = 2
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 2
  }

  load_balancer {
    target_group_name = "lamp-balancer"
  }
}
