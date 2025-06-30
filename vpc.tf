resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = { Name = "${var.project}-${var.environment}-vpc" }
}

data "aws_availability_zones" "azs" {}

resource "aws_subnet" "public" {
  for_each                = toset(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = data.aws_availability_zones.azs.names[index(var.public_subnets, each.value)]
  map_public_ip_on_launch = true
  tags = { Name = "public-${each.value}" }
}

resource "aws_subnet" "private" {
  for_each          = toset(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = data.aws_availability_zones.azs.names[index(var.private_subnets, each.value)]
  tags = { Name = "private-${each.value}" }
}

resource "aws_subnet" "db" {
  for_each          = toset(var.db_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = data.aws_availability_zones.azs.names[index(var.db_subnets, each.value)]
  tags = { Name = "db-${each.value}" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {}

# NAT Gateway to allow private subnets outbound
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public)[0].id
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
}
resource "aws_route_table_association" "private_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_network_acl" "public_acl" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = values(aws_subnet.public)[*].id
}
resource "aws_network_acl_rule" "public_in" {
  network_acl_id = aws_network_acl.public_acl.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}
resource "aws_network_acl_rule" "public_out" {
  network_acl_id = aws_network_acl.public_acl.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl" "private_acl" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = values(aws_subnet.private)[*].id
}
resource "aws_network_acl_rule" "private_in" {
  network_acl_id = aws_network_acl.private_acl.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}
resource "aws_network_acl_rule" "private_out" {
  network_acl_id = aws_network_acl.private_acl.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}
