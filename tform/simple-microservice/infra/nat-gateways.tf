# connects private subnet 1 with internet. 

resource "aws_eip" "elastic-ip-vpc-nat-gateway1" {
  vpc      = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.elastic-ip-vpc-nat-gateway1.id
  subnet_id     = aws_subnet.public_subnet1.id
  

  tags = {
    Name = "gw NAT"
  }
}