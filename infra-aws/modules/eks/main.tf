resource "aws_eks_cluster" "this" {
name = var.cluster_name
role_arn = var.cluster_role_arn
vpc_config { subnet_ids = var.subnet_ids }
}


resource "aws_eks_node_group" "this" {
cluster_name = aws_eks_cluster.this.name
node_group_name = "ng-${var.cluster_name}"
node_role_arn = var.node_role_arn
subnet_ids = var.subnet_ids
scaling_config {
  desired_size = var.node_count
  max_size     = var.node_count + 2
  min_size     = 1
}
instance_types = [var.node_instance_type]
}


output "cluster_name" { value = aws_eks_cluster.this.name }
output "cluster_endpoint" { value = aws_eks_cluster.this.endpoint }