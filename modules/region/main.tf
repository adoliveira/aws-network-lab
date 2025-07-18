terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = "${var.region_name}-vpc"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.region_name}-igw"
  })
}

# Subnets Públicas (uma por AZ)
resource "aws_subnet" "public" {
  count = length(var.availability_zones)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.region_name}-public-subnet-${substr(var.availability_zones[count.index], -1, 1)}"
    Type = "Public"
  })
}

# Subnets Privadas (duas por AZ)
resource "aws_subnet" "private" {
  count = length(var.availability_zones) * 2

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[floor(count.index / 2)][count.index % 2]
  availability_zone = var.availability_zones[floor(count.index / 2)]

  tags = merge(var.tags, {
    Name = "${var.region_name}-private-subnet-${substr(var.availability_zones[floor(count.index / 2)], -1, 1)}-${count.index % 2 + 1}"
    Type = "Private"
  })
}

# Elastic IPs para NAT Gateways
resource "aws_eip" "nat" {
  count = length(var.availability_zones)

  domain     = "vpc"
  depends_on = [aws_internet_gateway.main]

  tags = merge(var.tags, {
    Name = "${var.region_name}-eip-nat-${substr(var.availability_zones[count.index], -1, 1)}"
  })
}

# NAT Gateways (um por AZ)
resource "aws_nat_gateway" "main" {
  count = length(var.availability_zones)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(var.tags, {
    Name = "${var.region_name}-nat-gateway-${substr(var.availability_zones[count.index], -1, 1)}"
  })

  depends_on = [aws_internet_gateway.main]
}

# Route Table para subnets públicas
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.tags, {
    Name = "${var.region_name}-public-rt"
  })
}

# Associação das subnets públicas com a route table pública
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Route Tables para subnets privadas (uma por AZ)
resource "aws_route_table" "private" {
  count = length(var.availability_zones)

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = merge(var.tags, {
    Name = "${var.region_name}-private-rt-${substr(var.availability_zones[count.index], -1, 1)}"
  })
}

# Associação das subnets privadas com suas respectivas route tables
resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[floor(count.index / 2)].id
}
