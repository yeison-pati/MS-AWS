# Trae la VPC por defecto
data "aws_vpc" "default" {
  default = true
}

# Trae las subnets que están en la VPC por defecto
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}


output "vpc_id" { value = aws_vpc.default.id }
output "private_subnets" { value = aws_subnets.default.private[*].id }
output "public_subnets" { value = aws_subnets.default.public[*].id }
