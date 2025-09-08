# En tu módulo EKS
resource "aws_eks_cluster" "my_eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  
  vpc_config {
    subnet_ids              = concat(var.public_subnets, var.private_subnets)
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
  ]
}

resource "aws_eks_node_group" "my_eks_node_group" {
  cluster_name    = aws_eks_cluster.my_eks_cluster.name
  node_group_name = "ng-${var.cluster_name}"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = var.private_subnets  # Solo subredes privadas para los nodos
  
  scaling_config {
    desired_size = var.node_count
    max_size     = var.node_count + 2
    min_size     = 1
  }
  
  instance_types = [var.node_instance_type]
  
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_read_only,
    aws_iam_role_policy_attachment.eks_cni_policy,
  ]
}


output "cluster_name" { value = aws_eks_cluster.my_eks_cluster.name }
output "cluster_endpoint" { value = aws_eks_cluster.my_eks_cluster.endpoint }