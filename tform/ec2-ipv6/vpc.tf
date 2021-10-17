variable "ami_key_pair_name" {
}

resource "aws_vpc" "region_vpc" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support = true

  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "main-infravpc"
  }
}
