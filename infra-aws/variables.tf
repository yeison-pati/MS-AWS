variable "region" {
  type    = string
  default = "us-east-1"
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
  default = "dbadmin"

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
  default = "dbadmin"
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

# S3
variable "s3_buckets" {
  type    = map(any)
  default = { app = { name = "app-bucket-dev" } }
}



variable "service_names" {
  description = "A list of microservice names."
  type        = list(string)
  default = [
    "config-server",
    "discovery-service",
    "gateway",
    "order-service",
    "user-service"
  ]
}