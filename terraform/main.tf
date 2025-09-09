resource "random_password" "db_password" {
  length  = 16
  special = false
}

resource "random_string" "db_username" {
  length  = 8
  upper   = true
  lower   = true
  numeric = false
  special = false
}

# --- Red y Recursos Base ---

# Módulo VPC (Virtual Private Cloud)
# Crea la red principal donde se alojarán todos nuestros recursos.
# Esto incluye subredes públicas y privadas para controlar el acceso.
module "vpc" {
  source = "./modules/vpc"
}

# --- Bases de Datos ---

# Módulo PostgreSQL
# Crea una base de datos PostgreSQL en AWS RDS.
# Será utilizada por el 'order-service'.
module "postgres" {
  source            = "./modules/postgres"
  environment       = var.environment
  engine            = var.engine_postgres
  username          = random_string.db_username.result
  password          = random_password.db_password.result
  allocated_storage = var.db_allocated_storage_postgres
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnets
  db_name           = var.db_name_postgres
}

# Módulo MySQL
# Crea una base de datos MySQL en AWS RDS.
# Será utilizada por el 'user-service'.
module "mysql" {
  source            = "./modules/mysql"
  environment       = var.environment
  engine            = var.engine_mysql
  username          = random_string.db_username.result
  password          = random_password.db_password.result
  allocated_storage = var.db_allocated_storage_mysql
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnets
  db_name           = var.db_name_mysql
}

# --- Orquestación de Contenedores ---

# Módulo EKS (Elastic Kubernetes Service)
# Crea un clúster de Kubernetes para desplegar y gestionar nuestros microservicios.
module "eks" {
  source             = "./modules/eks"
  cluster_name       = "my-eks-cluster-${var.environment}"
  vpc_id             = module.vpc.vpc_id
  public_subnets     = module.vpc.public_subnets
  private_subnets    = module.vpc.private_subnets
  node_count         = var.eks_node_count
  node_instance_type = var.eks_node_instance_type
}

# Módulo ECR (Elastic Container Registry)
# Crea repositorios de imágenes Docker, uno para cada microservicio.
# Aquí es donde subiremos nuestras imágenes para que EKS pueda usarlas.
module "ecr" {
  source        = "./modules/ecr"
  service_names = var.service_names
}

# --- Monitoreo y Otros Servicios ---

# Módulo CloudWatch
# Configura el monitoreo y la recolección de logs para nuestros servicios.
module "cloudwatch" {
  source      = "./modules/cloudwatch"
  environment = var.environment
}

# Módulo S3 (Simple Storage Service)
# Crea buckets de S3 para almacenamiento de objetos.
module "s3" {
  source      = "./modules/s3"
  buckets     = var.s3_buckets
  environment = var.environment
}