terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.59.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region = var.region
}

resource "aws_vpc" "region_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "main-infravpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.region_vpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = "${aws_vpc.region_vpc.id}"
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
}

resource "aws_route_table" "route_table_pvt_subnet_nat" {
  vpc_id = "${aws_vpc.region_vpc.id}"
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat.id}"
  }
}

resource "aws_route_table_association" "subnet1-association" {
  subnet_id      = "${aws_subnet.public_subnet1.id}"
  route_table_id = "${aws_route_table.route_table.id}"
}

resource "aws_route_table_association" "subnet2-association" {
  subnet_id      = "${aws_subnet.public_subnet2.id}"
  route_table_id = "${aws_route_table.route_table.id}"
}

resource "aws_route_table_association" "pvt-subnet1-association" {
  subnet_id      = "${aws_subnet.private_subnet1.id}"
  route_table_id = "${aws_route_table.route_table_pvt_subnet_nat.id}"
}

resource "aws_route_table_association" "pvt-subnet2-association" {
  subnet_id      = "${aws_subnet.private_subnet2.id}"
  route_table_id = "${aws_route_table.route_table_pvt_subnet_nat.id}"
}
