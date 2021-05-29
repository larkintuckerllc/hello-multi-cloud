locals {
  private_subnet = {
    0 = {
      availability_zone = "us-east-2a"
      cidr_block        = "10.0.64.0/18"
    },
    1 = {
      availability_zone = "us-east-2b"
      cidr_block        = "10.0.128.0/18"
    }
  }
  private_subnet_ids = [for subnet in values(aws_subnet.private) : subnet.id]
  public_subnet = {
    0 = {
      availability_zone = "us-east-2a"
      cidr_block        = "10.0.0.0/24"
    },
    1 = {
      availability_zone = "us-east-2b"
      cidr_block        = "10.0.1.0/24"
    }
  }
  public_subnet_ids  = [for subnet in values(aws_subnet.public) : subnet.id]
  subnet_ids         = concat(local.private_subnet_ids, local.public_subnet_ids)
  vpc_cidr_block     = "10.0.0.0/16"
  private_rt_ids     = [for rt in aws_route_table.private : rt.id]
}

# VPC

resource "aws_vpc" "this" {
  cidr_block = local.vpc_cidr_block
  tags = {
    Infrastructure = var.identifier
    Name           = var.identifier
  }
}

# SUBNETS

resource "aws_subnet" "private" {
  for_each          = local.private_subnet
  availability_zone = each.value["availability_zone"]
  cidr_block        = each.value["cidr_block"]
  tags = {
    Infrastructure                            = var.identifier
    Name                                      = "${var.identifier}-private-${each.key}"
    "kubernetes.io/cluster/${var.identifier}" = "shared"
    "kubernetes.io/role/internal-elb"         = "1"
    Tier                                      = "private"
  }
  vpc_id = aws_vpc.this.id
}

resource "aws_subnet" "public" {
  for_each                = local.public_subnet
  availability_zone       = each.value["availability_zone"]
  cidr_block              = each.value["cidr_block"]
  map_public_ip_on_launch = true
  tags = {
    Infrastructure                            = var.identifier
    Name                                      = "${var.identifier}-public-${each.key}"
    "kubernetes.io/cluster/${var.identifier}" = "shared"
    "kubernetes.io/role/elb"                  = "1"
    Tier                                      = "public"
  }
  vpc_id = aws_vpc.this.id
}

# GATEWAYS

resource "aws_internet_gateway" "this" {
  tags = {
    Infrastructure = var.identifier
    Name           = var.identifier
  }
  vpc_id = aws_vpc.this.id
}

resource "aws_eip" "this" {
  for_each   = local.public_subnet
  depends_on = [aws_internet_gateway.this]
  tags = {
    Infrastructure = var.identifier
    Name           = "${var.identifier}-${each.key}"
  }
  vpc = true
}

resource "aws_nat_gateway" "this" {
  for_each      = local.public_subnet
  allocation_id = aws_eip.this[each.key].id
  subnet_id     = aws_subnet.public[each.key].id
  tags = {
    Infrastructure = var.identifier
    Name           = "${var.identifier}-${each.key}"
  }
}

# ROUTE TABLES

resource "aws_route_table" "private" {
  for_each = local.private_subnet
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[each.key].id
  }
  tags = {
    Infrastructure = var.identifier
    Name           = "${var.identifier}-private-${each.key}"
  }
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "public" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Infrastructure = var.identifier
    Name           = "${var.identifier}-public"
  }
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table_association" "private" {
  for_each = local.private_subnet
  route_table_id = aws_route_table.private[each.key].id
  subnet_id      = aws_subnet.private[each.key].id
}

resource "aws_route_table_association" "public" {
  for_each = local.public_subnet
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[each.key].id
}

# NETWORK ACL

resource "aws_network_acl" "this" {
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  subnet_ids = local.subnet_ids
  tags = {
    Infrastructure = var.identifier
    Name           = "${var.identifier}"
  }
  vpc_id = aws_vpc.this.id
}
