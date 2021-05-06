resource "aws_subnet" "test-subnet-1" {
  #   vpc_id = aws_vpc.test-vpc.id
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_block
  availability_zone = "us-east-1a"
  tags = {
    Name : "${var.env_prefix}-subnet-1"
  }
}

resource "aws_internet_gateway" "test-igw" {

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env_prefix}-igw"
  }
}

resource "aws_route_table" "test-route-table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-igw.id
  }

  tags = {
    Name = "${var.env_prefix}-rtb"
  }
}

resource "aws_route_table_association" "test-a-rtb-subnet" {
  subnet_id      = aws_subnet.test-subnet-1.id
  route_table_id = aws_route_table.test-route-table.id
}