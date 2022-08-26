variable nodes {
  type        = map
  description = "List of machines to build"
}

variable image {
  type        = string
  # default     = "https://app.vagrantup.com/ubuntu/boxes/focal64/versions/20220715.0.0/providers/virtualbox.box"
  # default = "https://app.vagrantup.com/ubuntu/boxes/bionic64/versions/20180903.0.0/providers/virtualbox.box"
  # default = "https://app.vagrantup.com/generic/boxes/centos8/versions/4.1.0/providers/virtualbox.box"
  # there is no need to use URL because the provider downloads it every time when we start it
  # to speed up the process it's better to use local file
  default = "virtualbox.box"
  description = "VirtualBox image"
}

variable ssh_user {
  type = string
  default = "vagrant"
  description = "The user to connect to built machines"
}

variable host_interface {
  type        = string
  default     = "enp5s1"
  description = "Host Network interface forbridged connection"
}
