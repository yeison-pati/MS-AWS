# high-level module wiring
module "vpc" {
  source      = "./modules/vpc"
}

module "dynamodb" {
  source      = "./modules/dynamodb"
  environment = var.environment
}


module "postgres" {
  environment       = var.environment
  source            = "./modules/postgres"
  engine            = var.engine_postgres
  username          = var.db_username_postgres
  password          = var.db_password_postgres
  allocated_storage = var.db_allocated_storage_postgres
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnets
}

module "mysql" {
  environment       = var.environment
  source            = "./modules/mysql"
  engine            = var.engine_mysql
  username          = var.db_username_mysql
  password          = var.db_password_mysql
  allocated_storage = var.db_allocated_storage_mysql
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnets
}


module "eks" {
  source             = "./modules/eks"
  cluster_name       = "my-eks-cluster-${var.environment}"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnets
  node_count         = var.eks_node_count
  node_instance_type = var.eks_node_instance_type
  cluster_role_arn   = var.eks_cluster_role_arn
  node_role_arn      = var.eks_node_role_arn
}


module "s3" {
  source      = "./modules/s3"
  buckets     = var.s3_buckets
  environment = var.environment
}


module "lambda" {

  source       = "./modules/lambda"
  environment  = var.environment
  package_file = var.lambda_package_file
  handler      = var.lambda_handler
  runtime      = var.lambda_runtime
}


module "api_gateway" {
  source      = "./modules/api_gateway"
  environment = var.environment
}


module "ec2" {
  source      = "./modules/ec2"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.public_subnets
  environment = var.environment
}


module "cloudwatch" {
  source      = "./modules/cloudwatch"
  environment = var.environment
}
