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


module "gateway" {
  source      = "./modules/gateway"
  environment = var.environment
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
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

module "ecr" {
  source        = "./modules/ecr"
  service_names = var.service_names
}
