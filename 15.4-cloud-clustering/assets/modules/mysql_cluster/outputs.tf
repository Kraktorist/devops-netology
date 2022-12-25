output cluster_id {
  value       = yandex_mdb_mysql_cluster.cluster.id
  description = "MySQL Cluster ID"
}

output fqdn {
  value       = yandex_mdb_mysql_cluster.cluster.host[*].fqdn
  description = "MySQL Cluster FQDN"
}
