module networks {
  source = "./modules/networks"
  network_name = var.network_name
  subnets      = [
    {
    "name" = "subnet-a"
    "cidr_blocks" = ["192.168.0.0/24"]
    "zone"        = "ru-central1-a"
    "description" = "mysql subnet"
    },
    {
    "name" = "subnet-b"
    "cidr_blocks" = ["192.168.1.0/24"]
    "zone"        = "ru-central1-b"
    "description" = "mysql subnet"
    }
  ]
}

module mysql_cluster {
  source = "./modules/mysql_cluster"
  cluster_network_id = module.networks.network_id
  subnets = module.networks.subnets
  cluster_resources = {
    "resource_preset_id" = "b1.medium"
    "disk_type_id"       = "network-ssd"
    "disk_size"          = 20
  }
  backup_window_start = {
    hours = 23
    minutes = 59
  }
  maintenance_window = {
    "type"  = "ANYTIME"
    "day"   = null
    "hour"  = null
  }
  deletion_protection = true
}

module mysql_db {
  source = "./modules/mysql_db"
  cluster_id = module.mysql_cluster.cluster_id
  database = "netology_db"
}

module mysql_user {
  source = "./modules/mysql_user"
  cluster_id = module.mysql_cluster.cluster_id
  username = "netology_db"
  roles = [
    {
      database = "netology_db"
      roles = ["ALL"]
    }
  ]
}