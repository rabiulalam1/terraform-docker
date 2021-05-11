###################
# Public Subnet A #
###################
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
  cidr_block        = var.subnet_cidr_block_public_a
  availability_zone = "${var.region}a"
  tags = {
    Name : "${terraform.workspace}-public-subnet-a"
  }
}

resource "aws_route_table" "public_a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${terraform.workspace}-public-a-rtb"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_a.id
}

resource "aws_eip" "public_a" {
  vpc = true

  tags = {
    Name = "${terraform.workspace}-a-eip"
  }  
}

resource "aws_nat_gateway" "public_a" {
  allocation_id = aws_eip.public_a.id
  subnet_id = aws_subnet.public_a.id

  tags = {
    Name = "${terraform.workspace}-a-ngw"
  }
}

####################
# Public Subnet B #
####################

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_block_public_b
  availability_zone = "${var.region}b"
  map_public_ip_on_launch = true

  tags = {
    Name : "${terraform.workspace}-public-subnet-b"
  }
}

resource "aws_route_table" "public_b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${terraform.workspace}-public-b-rtb"
  }
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_b.id
}

resource "aws_eip" "public_b" {
  vpc = true

  tags = {
    Name = "${terraform.workspace}-b-eip"
  }  
}

resource "aws_nat_gateway" "public_b" {
  allocation_id = aws_eip.public_b.id
  subnet_id = aws_subnet.public_b.id

  tags = {
    Name = "${terraform.workspace}-b-ngw"
  }
}

####################
# Private Subnet A #
####################

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_block_private_a
  availability_zone = "${var.region}a"
  
  tags = {
    Name : "${terraform.workspace}-private-subnet-a"
  }
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public_a.id
  }

  tags = {
    Name = "${terraform.workspace}-private-a-rtb"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

####################
# Private Subnet B #
####################

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_block_private_b
  availability_zone = "${var.region}a"
  tags = {
    Name : "${terraform.workspace}-private-subnet-b"
  }
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public_b.id
  }

  tags = {
    Name = "${terraform.workspace}-private-b-rtb"
  }
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_b.id
}