output "ecr_repository_url" {
  description = "The URL of the repository."
  value       = aws_ecr_repository.aws-ecr.repository_url
}

output "ecr_repository_id" {
  description = "The account ID of the registry holding the repository"
  value       = aws_ecr_repository.aws-ecr.repository_url
}
