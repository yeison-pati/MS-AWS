variable "cluster_name" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "node_count" { type = number }
variable "node_instance_type" { type = string }
variable "cluster_role_arn" { type = string }
variable "node_role_arn" { type = string }