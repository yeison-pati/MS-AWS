output "cluster_role_arn" {
  description = "The ARN of the EKS cluster IAM role."
  value       = aws_iam_role.eks_cluster_role.arn
}

output "node_group_role_arn" {
  description = "The ARN of the EKS node group IAM role."
  value       = aws_iam_role.eks_node_group_role.arn
}