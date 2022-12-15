resource "yandex_alb_load_balancer" "lamp-balancer" {
  name        = "lamp-balancer"

  network_id  = yandex_vpc_network.network.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.public.id 
    }
  }

  listener {
    name = "alb-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 80 ]
    }    
    http {
      handler {
        http_router_id = yandex_alb_http_router.router.id
      }
    }
  }
}

resource "yandex_alb_http_router" "router" {
  name      = "http-router"
}

resource "yandex_alb_backend_group" "lamp-group" {
  name      = "lamp-group"

  http_backend {
    name = "lamp-backend"
    weight = 1
    port = 80
    target_group_ids = [yandex_compute_instance_group.alb_lamp_group.application_load_balancer[0].target_group_id]
    load_balancing_config {
      panic_threshold = 33
    }    
    healthcheck {
      timeout = "1s"
      interval = "1s"
      http_healthcheck {
        path  = "/"
      }
    }
  }
}

resource "yandex_alb_virtual_host" "lamp-virtual-host" {
  name      = "lamp-virtual-host"
  http_router_id = yandex_alb_http_router.router.id
  route {
    name = "route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.lamp-group.id
        timeout = "3s"
      }
    }
  }
}