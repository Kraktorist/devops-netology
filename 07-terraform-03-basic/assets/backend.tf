terraform {
  backend "s3" {
    bucket = "kraktorist-dn-tf-backend"
    key    = "07-terraform-03-basic/terraform_state"
  }
}