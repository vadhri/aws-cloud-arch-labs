resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.region_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.az1
  
  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.region_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.az2

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet1" {
  vpc_id                  = aws_vpc.region_vpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = false
  availability_zone       = var.az1

  tags = {
    Name = "private_subnet"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id                  = aws_vpc.region_vpc.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = false
  availability_zone       = var.az2

  tags = {
    Name = "private_subnet"
  }
}

resource "aws_subnet" "db_private_subnet1" {
  vpc_id                  = aws_vpc.region_vpc.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = false
  availability_zone       = var.db_az1

  tags = {
    Name = "db private_subnet"
  }
}

resource "aws_subnet" "db_private_subnet2" {
  vpc_id                  = aws_vpc.region_vpc.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = false
  availability_zone       = var.db_az2

  tags = {
    Name = "db private_subnet"
  }
}

resource "aws_subnet" "replica_db_private_subnet1" {
  vpc_id                  = aws_vpc.region_vpc.id
  cidr_block              = "10.0.7.0/24"
  map_public_ip_on_launch = false
  availability_zone       = var.db_az1

  tags = {
    Name = "db private_subnet"
  }
}

resource "aws_subnet" "replica_db_private_subnet2" {
  vpc_id                  = aws_vpc.region_vpc.id
  cidr_block              = "10.0.8.0/24"
  map_public_ip_on_launch = false
  availability_zone       = var.db_az2

  tags = {
    Name = "db private_subnet"
  }
}
