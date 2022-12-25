output username {
  value       = yandex_mdb_mysql_user.user.name
  sensitive   = true
  description = "MySQL Username"
}

output password {
  value       = random_password.password.result
  sensitive   = true
  description = "MySQL Password"
}

