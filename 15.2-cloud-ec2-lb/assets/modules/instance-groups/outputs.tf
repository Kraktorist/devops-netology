output target_group_id {
  value       = var.balancer == "nlb" ? yandex_compute_instance_group.lamp_group.load_balancer[0].target_group_id : yandex_compute_instance_group.lamp_group.application_load_balancer[0].target_group_id
  description = "Target Group ID"
}
