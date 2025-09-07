# Crea la VPC principal (si no existe, puedes cambiar el cidr_block si lo necesitas)
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

# Crea una subred pública
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "public-subnet-a"
    Tier = "Public"
  }
}

# Crea una subred privada
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-subnet-a"
    Tier = "Private"
  }
}

# Crea una subred pública en otra AZ
resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "public-subnet-b"
    Tier = "Public"
  }
}

# Crea una subred privada en otra AZ
resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private-subnet-b"
    Tier = "Private"
  }
}

output "vpc_id" { value = aws_vpc.main.id }
output "public_subnets" { value = [aws_subnet.public_a.id, aws_subnet.public_b.id] }
output "private_subnets" { value = [aws_subnet.private_a.id, aws_subnet.private_b.id] }
