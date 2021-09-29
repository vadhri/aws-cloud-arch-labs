resource "aws_instance" "web_server1" {
  ami               = "ami-0cf5ecd839872ea62"
  instance_type     = "t2.micro"
  availability_zone = var.az1
  subnet_id = aws_subnet.public_subnet1.id
  key_name = aws_key_pair.generated_key_pair.key_name
  security_groups = ["${aws_security_group.security.id}"]
  
  tags = {
    Name = "Web server - public servers"
  }
}

resource "aws_instance" "app_server1" {
  ami               = "ami-087c17d1fe0178315"
  instance_type     = "t2.micro"
  availability_zone = var.az1
  subnet_id = aws_subnet.private_subnet1.id
  key_name = aws_key_pair.generated_key_pair.key_name
  security_groups = ["${aws_security_group.security.id}"]

  tags = {
    Name = "App server 1"
  }
}

resource "aws_eip" "elastic-ip" {
  instance = "${aws_instance.web_server1.id}"
  vpc      = true
}

