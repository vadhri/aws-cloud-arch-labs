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
  region = "us-east-1"
}

variable "ami_key_pair_name" {}

resource "tls_private_key" "pvtkey" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "generated_key_pair" {
  key_name = "aws_ec2_key_pair"
  public_key = tls_private_key.pvtkey.public_key_openssh

  provisioner "local-exec" { 
    command = "echo '${tls_private_key.pvtkey.private_key_pem}' > ./ec-access.pem"
  }
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

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.region_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_instance" "app_server" {
  ami               = "ami-087c17d1fe0178315"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  subnet_id = aws_subnet.public_subnet.id
  key_name = aws_key_pair.generated_key_pair.key_name
  security_groups = ["${aws_security_group.security.id}"]

  tags = {
    Name = "ec2-amazon-linux-t2micro"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = "${aws_vpc.region_vpc.id}"
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.route_table.id}"
}

resource "aws_eip" "elastic-ip" {
  instance = "${aws_instance.app_server.id}"
  vpc      = true
}
