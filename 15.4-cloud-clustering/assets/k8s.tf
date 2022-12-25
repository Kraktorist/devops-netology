module service_account {
  source = "./modules/service_account"
  folder_name = "devops-netology"
  name = "k8s-cluster"
  description = "k8s cluster account"
  role = "editor"
}

module k8s_networks {
  source = "./modules/networks"
  network_name = "default"
  subnets      = [
    {
    "name" = "k8s-subnet-a"
    "cidr_blocks" = ["192.168.10.0/24"]
    "zone"        = "ru-central1-a"
    "description" = "k8s subnet"
    },
    {
    "name" = "k8s-subnet-b"
    "cidr_blocks" = ["192.168.11.0/24"]
    "zone"        = "ru-central1-b"
    "description" = "k8s subnet"
    },
    {
    "name" = "k8s-subnet-c"
    "cidr_blocks" = ["192.168.12.0/24"]
    "zone"        = "ru-central1-c"
    "description" = "k8s subnet"
    }
  ]
}

module k8s_cluster {
  source = "./modules/k8s_cluster"
  cluster_name = "k8s-cluster"
  description = "DevOps cluster"
  cluster_network_id = module.k8s_networks.network_id
  subnets = module.k8s_networks.subnets
  cluster_version = "1.22"
  public_ip = true
  cluster_sa_id = module.service_account.id
  node_sa_id = module.service_account.id
}

module k8s_nodes {
  for_each = { for subnet in module.k8s_networks.subnets : subnet.id => subnet }
  source = "./modules/k8s_nodes"
  cluster_id = module.k8s_cluster.id
  name = "k8s-cluster"
  description = "DevOps Cluster"
  cluster_version = "1.22"
  scale_policy = {
    min = 1
    max = 2
    initial = 1
  }
  subnet = each.value
}
