resource "aws_internet_gateway" "Internet-Gateway" {
    vpc_id = aws_vpc.region_vpc.id
}

resource "aws_egress_only_internet_gateway" "Egress-Only-Internet-Gateway" {
    vpc_id = aws_vpc.region_vpc.id
}
resource "aws_route_table" "Route-Table-Subnet-Igw" {
    vpc_id = aws_vpc.region_vpc.id

  tags = {
    Name = "ipv4 and ipv6 Route-Table-Subnet-Igw"
  }
}

resource "aws_route" "r4" {
  route_table_id            = aws_route_table.Route-Table-Subnet-Igw.id
  
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.Internet-Gateway.id

  depends_on                = [aws_route_table.Route-Table-Subnet-Igw]
}

resource "aws_route" "r6" {
  route_table_id            = aws_route_table.Route-Table-Subnet-Igw.id
  
  destination_ipv6_cidr_block = "::/0"
  gateway_id = aws_internet_gateway.Internet-Gateway.id

  depends_on                = [aws_route_table.Route-Table-Subnet-Igw]
}


resource "aws_route_table_association" "Rta-Igw-Subnet" {
    route_table_id = aws_route_table.Route-Table-Subnet-Igw.id 
    subnet_id = aws_subnet.Ip-V6-Subnet.id
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.Ip-V6-Subnet.id}"
  route_table_id = "${aws_route_table.Route-Table-Subnet-Igw.id}"
}

resource "aws_eip" "elastic-ip" {
  instance = "${aws_instance.app_server.id}"
  vpc      = true
}
