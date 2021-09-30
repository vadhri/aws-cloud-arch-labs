resource "aws_lb" "webserver_lb" {
  name               = "webserver-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.security.id]
  
  subnet_mapping {
    subnet_id     = aws_subnet.public_subnet1.id
    allocation_id = aws_eip.alb-elastic-ip.allocation_id
  }

  subnet_mapping {
    subnet_id     = aws_subnet.public_subnet2.id
    allocation_id = aws_eip.alb-elastic-ip2.allocation_id
  }  

  access_logs {
    bucket  = aws_s3_bucket.alb_logs.bucket
    prefix  = "webserver-alb"
  }
}

resource "aws_lb" "dbserver_lb" {
  name               = "dbserver-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.security.id]
  
  subnet_mapping {
    subnet_id     = aws_subnet.private_subnet1.id
  }

  subnet_mapping {
    subnet_id     = aws_subnet.private_subnet2.id
  }  

  access_logs {
    bucket  = aws_s3_bucket.alb_logs.bucket
    prefix  = "webserver-alb"
  }
}


resource "aws_lb_target_group" "frontendtg" {
  name     = "frontend-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.region_vpc.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.webserver_lb.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontendtg.arn
  }
}



resource "aws_lb_listener" "front_end_80" {
  load_balancer_arn = aws_lb.webserver_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontendtg.arn
  }
}

resource "aws_lb_listener" "front_end_443" {
  load_balancer_arn = aws_lb.webserver_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  certificate_arn = "XXXXXX"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontendtg.arn
  }
}

resource "aws_eip" "alb-elastic-ip" {
  vpc      = true
}

resource "aws_eip" "alb-elastic-ip2" {
  vpc      = true
}

resource "aws_s3_bucket" "alb_logs" {
    bucket = "alb-s3-logs-09-21-v01"
    acl    = "private"
}

resource "aws_lb_target_group" "ALb-Target-Group-DB-Servers" {
  name     = "db-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.region_vpc.id
}

resource "aws_lb_listener" "LBListener" {
  load_balancer_arn = aws_lb.webserver_lb.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontendtg.arn
  }
}
