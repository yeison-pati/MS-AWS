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
##PostgreSQL
variable "engine_postgres" {
  type    = string
  default = "postgres"
}

variable "db_name_postgres" {
  type    = string
  default = "orders"
}

variable "db_username_postgres" {
  type    = string
  default = "value"
}

variable "db_password_postgres" {
  type    = string
  default = "value"
}

variable "db_allocated_storage_postgres" {
  type    = number
  default = 20
}

##MySQL
variable "engine_mysql" {
  type    = string
  default = "mysql"
}

variable "db_name_mysql" {
    type = string
    default = "users"  
}

variable "db_username_mysql" {
  type    = string
  default = "value"
}

variable "db_password_mysql" {
  type    = string
  default = "value"
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
  default = {
    app = {
      name = "app-bucket-dev"
    }
    logs = {
      name = "logs-bucket-dev"
    }
  }
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