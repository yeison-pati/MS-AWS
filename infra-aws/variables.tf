variable "region" {
  type    = string
  default = "us-east-1"
}

variable "access_key" {
  type    = string
  description = "AWS access key"
  sensitive = true
}

variable "secret_key" {
  type        = string
  description = "AWS secret key"
  sensitive   = true
}

variable "state_bucket" {
  type    = string
  default = "my-terraform-state-bucket"
}


variable "environment" {
  type    = string
  default = "dev"
}


# RDS
variable "engine_postgres" {
  type    = string
  default = "postgres"
}

variable "engine_mysql" {
  type    = string
  default = "mysql"
}

variable "db_username_postgres" {
  type    = string
  default = "admin"
}
variable "db_password_postgres" {
  type    = string
  default = "password"
}
variable "db_allocated_storage_postgres" {
  type    = number
  default = 20
}


variable "db_username_mysql" {
  type    = string
  default = "admin"
}
variable "db_password_mysql" {
  type    = string
  default = "password"
}
variable "db_allocated_storage_mysql" {
  type    = number
  default = 20
}


# EKS
variable "eks_node_count" {
  type    = number
  default = 2
}
variable "eks_node_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "eks_cluster_role_arn" {
  type    = string
  default = "arn:aws:iam::123456789012:role/eks-cluster-role"
}
variable "eks_node_role_arn" {
  type    = string
  default = "arn:aws:iam::123456789012:role/eks-node-role"
  
}


# S3
variable "s3_buckets" {
  type    = map(any)
  default = { app = { name = "app-bucket-${var.environment}" } }
}

# Lambda
variable "lambda_handler" {
  type    = string
  default = "index.handler"
}
variable "lambda_runtime" {
  type    = string
  default = "nodejs14.x"
}

variable "lambda_package_file" {
  type    = string
  default = "lambda_function_payload.zip"
  
}
