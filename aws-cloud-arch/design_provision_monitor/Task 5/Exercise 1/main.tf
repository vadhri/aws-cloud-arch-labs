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

resource "aws_instance" "t2micro" {
    count = 2
    ami               = "ami-087c17d1fe0178315"
    instance_type     = "t2.micro"
    availability_zone = "us-east-1f"
    subnet_id = var.public_subnet

    tags = {
    Name = "Udacity T2 micro ${count.index + 1}"
    }
}

resource "aws_instance" "m4large" {
    count = 2
    ami               = "ami-087c17d1fe0178315"
    instance_type     = "m4.large"
    availability_zone = "us-east-1f"
    subnet_id = var.public_subnet

    tags = {
    Name = "Udacity M4 ${count.index + 1}"
    }
}