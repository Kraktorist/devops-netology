terraform {
  backend "s3" {
    bucket = "kraktorist-dn-tf-backend"
    key    = "07-terraform-04-basic/terraform_state"
  }
}