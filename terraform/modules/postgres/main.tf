# Simple single-AZ RDS instance (for demos). For production use Multi-AZ and subnet groups.
resource "aws_db_subnet_group" "this" {
  name       = "rds-postgres-subnet-group-${var.environment}"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "postgres" {
  identifier           = "rds-postgres-${var.environment}"
  engine               = var.engine
  instance_class       = "db.t3.micro"
  allocated_storage    = var.allocated_storage
  username             = var.username
  password             = var.password
  db_name              = var.db_name
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.this.name
  publicly_accessible  = false
  tags                 = { Environment = var.environment }
}

output "endpoint" { value = aws_db_instance.postgres.endpoint }
output "port"     { value = aws_db_instance.postgres.port }
output "db_name"  { value = var.db_name }
output "username" { value = var.username }
output "password" { value = var.password }