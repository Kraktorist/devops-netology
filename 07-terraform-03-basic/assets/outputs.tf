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
  value = aws_instance.aws-ubuntu[*].private_ip
}

output "aws_private_ips2" {
  value = [
    for instance in aws_instance.aws-ubuntu2 : instance.private_ip
  ]
}
