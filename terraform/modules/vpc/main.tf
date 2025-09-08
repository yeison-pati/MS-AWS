# Crea la VPC principal
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "ms-aws-vpc"
    tags = "MainVPC"
  }
}

# Internet Gateway para conectividad pública
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "ms-aws-igw"
  }
}

# Elastic IP para NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.main]
  tags = {
    Name = "ms-aws-nat-eip"
  }
}


# Subredes públicas
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name                        = "public-subnet-a"
    Tier                        = "Public"
    "kubernetes.io/role/elb"    = "1"
    "kubernetes.io/cluster/my-eks-cluster-dev" = "shared"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name                        = "public-subnet-b"
    Tier                        = "Public"
    "kubernetes.io/role/elb"    = "1"
    "kubernetes.io/cluster/my-eks-cluster-dev" = "shared"
  }
}

# Subredes privadas
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name                                = "private-subnet-a"
    Tier                                = "Private"
    "kubernetes.io/role/internal-elb"   = "1"
    "kubernetes.io/cluster/my-eks-cluster-dev" = "owned"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name                                = "private-subnet-b"
    Tier                                = "Private"
    "kubernetes.io/role/internal-elb"   = "1"
    "kubernetes.io/cluster/my-eks-cluster-dev" = "owned"
  }
}

# NAT Gateway para que las subredes privadas tengan acceso a internet
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_a.id
  depends_on    = [aws_internet_gateway.main]
  tags = {
    Name = "ms-aws-nat-gateway"
  }
}


# Tabla de ruteo para subredes públicas
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "ms-aws-public-rt"
  }
}

# Ruta para tráfico público hacia Internet Gateway
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Asociar subredes públicas con la tabla de ruteo pública
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

# Tabla de ruteo para subredes privadas
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "ms-aws-private-rt"
  }
}

# Ruta para tráfico privado hacia NAT Gateway
resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

# Asociar subredes privadas con la tabla de ruteo privada
resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}

# Outputs
output "vpc_id" { 
  value = aws_vpc.main.id 
}
output "public_subnets" { 
  value = [aws_subnet.public_a.id, aws_subnet.public_b.id] 
}
output "private_subnets" { 
  value = [aws_subnet.private_a.id, aws_subnet.private_b.id] 
}
output "internet_gateway_id" {
  value = aws_internet_gateway.main.id
}
output "nat_gateway_id" {
  value = aws_nat_gateway.main.id
}