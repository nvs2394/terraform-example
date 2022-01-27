output "elb" {
  value = aws_elb.api-customer-elb.dns_name
}

output "api-customer-repository-URL" {
  value = aws_ecr_repository.api-customer.repository_url
}

