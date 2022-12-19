data "yandex_iam_service_account" "lamp" {
  service_account_id = var.service_account_id
}


module networks {
  source = "./modules/networks"
  network_name = var.network_name
  public_network = var.public_network
}

module buckets {
  source = "./modules/buckets"
  hosting_bucket = var.hosting_bucket
  picture_path = var.picture_path
}

module instance-groups {
  source = "./modules/instance-groups"
  lamp = var.lamp
  balancer = var.balancer
  service_account_id = data.yandex_iam_service_account.lamp.id
  subnet_id = module.networks.subnet_id
  user_data = var.user_data
}

module nlb {
  count = var.balancer == "nlb" ? 1 : 0
  source = "./modules/nlb"
  target_group_id = module.instance-groups.target_group_id
}

module alb {
  count = var.balancer == "alb" ? 1 : 0
  source = "./modules/alb"
  target_group_id = module.instance-groups.target_group_id
  network_id = module.networks.network_id
  subnet_id = module.networks.subnet_id
}
