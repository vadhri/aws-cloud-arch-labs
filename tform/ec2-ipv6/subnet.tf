resource "aws_subnet" "Ip-V6-Subnet" {
    vpc_id = aws_vpc.region_vpc.id
    cidr_block = "10.0.1.0/24"
    ipv6_cidr_block = "${cidrsubnet(aws_vpc.region_vpc.ipv6_cidr_block, 8, 1)}"
    map_public_ip_on_launch = true
    availability_zone       = "us-east-1a"
    assign_ipv6_address_on_creation = true

    tags = {
    Name = "public_subnet"
    }    
}