output "elb" {
  value = aws_elb.api-customer-elb.dns_name
}

output "jenkins" {
  value = aws_instance.jenkins-instance.public_ip
}

output "api-customer-repository-URL" {
  value = aws_ecr_repository.api-customer.repository_url
}

