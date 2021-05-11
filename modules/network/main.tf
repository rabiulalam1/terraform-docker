resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name : "${terraform.workspace}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${terraform.workspace}-igw"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = "${var.region}a"
  tags = {
    Name : "${terraform.workspace}-subnet-a"
  }
}

# resource "aws_route_table" "test-route-table" {
#   vpc_id = var.vpc_id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.test-igw.id
#   }

#   tags = {
#     Name = "${var.env_prefix}-rtb"
#   }
# }

# resource "aws_route_table_association" "test-a-rtb-subnet" {
#   subnet_id      = aws_subnet.test-subnet-1.id
#   route_table_id = aws_route_table.test-route-table.id
# }