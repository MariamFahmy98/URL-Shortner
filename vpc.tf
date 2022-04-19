resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_default_route_table" "route_table" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }
}

resource "aws_subnet" "first_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone_id    = "usw2-az1"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "second_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone_id    = "usw2-az2"
  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "first-subnet-association" {
  subnet_id      = aws_subnet.first_subnet.id
  route_table_id = aws_default_route_table.route_table.id
}

resource "aws_route_table_association" "second-subnet-association" {
  subnet_id      = aws_subnet.second_subnet.id
  route_table_id = aws_default_route_table.route_table.id
}
