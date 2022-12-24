variable cluster_id {
  type        = string
  description = "MySQL Cluster ID"
}

variable username {
  type        = string
  description = "MySQL Username"
}

variable roles {
  type        = list(object({
    database = string
    roles = list(string)
  }))
  description = "MySQL Roles to assign"
}

variable authentication_plugin {
  type        = string
  default     = "SHA256_PASSWORD"
  description = "Authentication plugin"
}

variable password_requirements {
  type        = object({
    length = string
    special = bool
  })
  default     = {
    length = 16
    special = true
  }
  description = "Password Requirements"
}
