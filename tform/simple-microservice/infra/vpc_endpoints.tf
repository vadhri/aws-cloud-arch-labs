resource "aws_vpc_endpoint" "rds_private_link" {
    vpc_id = aws_vpc.region_vpc.id
    service_name =  "com.amazonaws.us-east-1.rds"
    vpc_endpoint_type = "Interface"
    security_group_ids = [aws_security_group.security.id]
    subnet_ids = [aws_subnet.private_subnet2.id, aws_subnet.private_subnet1.id]
}
