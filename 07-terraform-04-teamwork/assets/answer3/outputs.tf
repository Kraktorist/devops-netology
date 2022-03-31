output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "aws_region" {
  value = data.aws_region.current.name
}

output "aws_private_ips" {
  value = module.ec2_instance[*].private_ip
}
