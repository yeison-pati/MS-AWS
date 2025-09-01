output "eks_cluster_name" {
  value       = module.eks.cluster_name
  description = "EKS cluster name"
  depends_on  = [module.eks]
}

output "s3_buckets" { value = module.s3.buckets }

output "ecr_repository_urls" {
  description = "The URLs of the ECR repositories."
  value       = module.ecr.repository_urls
}