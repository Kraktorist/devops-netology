terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.6"
    }
    yandex = {
      source = "terraform-registry.storage.yandexcloud.net/yandex-cloud/yandex"
      version = ">= 0.72"
    }
  }
}
