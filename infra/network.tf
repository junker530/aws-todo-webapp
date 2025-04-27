# ------------------------------------
# VPC
# ------------------------------------
resource "aws_vpc" "main" {
  cidr_block           = local.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project}-${var.environment}-vpc"
  }
}

# ------------------------------------
# Subnets
# ------------------------------------
resource "aws_subnet" "public" {
  count             = length(local.public_subnet_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(local.public_subnet_cidr_blocks, count.index)
  availability_zone = element(local.availability_zones, count.index)
  tags = {
    Name = "${var.project}-${var.environment}-public_subnet-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count             = length(local.private_subnet_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(local.private_subnet_cidr_blocks, count.index)
  availability_zone = element(local.availability_zones, count.index)
  tags = {
    Name = "${var.project}-${var.environment}-private_subnet-${count.index}"
  }
}

# ------------------------------------
# Internet Gateway
# ------------------------------------
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${var.environment}-igw"
  }
}

# ------------------------------------
# Route Table
# ------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${var.environment}-public-route-table"
  }
}

resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${var.environment}-private-route-table"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}