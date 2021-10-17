resource "aws_instance" "app_server" {
  ami               = "ami-087c17d1fe0178315"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  ipv6_address_count = 1

  subnet_id = aws_subnet.Ip-V6-Subnet.id
  key_name = aws_key_pair.generated_key_pair.key_name
  security_groups = ["${aws_security_group.Security-Group.id}"]

  tags = {
    Name = "ec2-amazon-linux-t2micro"
  }
}
