output "eks_cluster_name" {
  description = "El nombre del clúster de EKS."
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "El endpoint del clúster de EKS para configurar kubectl."
  value       = module.eks.cluster_endpoint
}

output "ecr_repository_urls" {
  description = "Las URLs de los repositorios de ECR para cada microservicio."
  value       = module.ecr.repository_urls
}

output "postgres_rds_endpoint" {
  description = "El endpoint de la base de datos PostgreSQL."
  value       = module.postgres.endpoint
}

output "postgres_rds_port" {
  description = "El puerto de la base de datos PostgreSQL."
  value       = module.postgres.port
  
}

output "postgres_rds_db_name" {
  description = "El nombre de la base de datos PostgreSQL."
  value       = module.postgres.db_name

}

output "postgres_rds_username" {
  description = "El nombre de usuario para la base de datos PostgreSQL."
  value       = module.postgres.username
  sensitive   = true
}

output "postgres_rds_password" {
  description = "La contraseña para la base de datos PostgreSQL."
  value       = module.postgres.password
  sensitive   = true
}



output "mysql_rds_endpoint" {
  description = "El endpoint de la base de datos MySQL."
  value       = module.mysql.endpoint
}

output "mysql_rds_port" {
  description = "El puerto de la base de datos MySQL."
  value       = module.mysql.port
}

output "mysql_rds_db_name" {
  description = "El nombre de la base de datos MySQL."
  value       = module.mysql.db_name
}

output "mysql_rds_username" {
  description = "El nombre de usuario para la base de datos MySQL."
  value       = module.mysql.username
  sensitive   = true
}

output "mysql_rds_password" {
  description = "La contraseña para la base de datos MySQL."
  value       = module.mysql.password
  sensitive   = true
}

output "s3_buckets" {
  description = "Los nombres de los buckets S3 creados."
  value       = module.s3.buckets
}