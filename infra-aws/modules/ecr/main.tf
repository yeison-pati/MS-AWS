resource "aws_ecr_repository" "this" {
  for_each = toset(var.service_names)
  name     = each.key
}

output "repository_urls" {
  description = "The URLs of the ECR repositories."
  value       = { for name, repo in aws_ecr_repository.this : name => repo.repository_url }
}