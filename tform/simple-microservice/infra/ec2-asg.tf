
resource "aws_launch_configuration" "launch_conf_frontend" {
  name_prefix   = "asg-launch-app-"
  image_id      = "ami-0cf5ecd839872ea62"
  instance_type = "t2.micro"
  key_name = aws_key_pair.generated_key_pair.key_name
  security_groups = ["${aws_security_group.security.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "launch_conf_db_servers" {
  name_prefix   = "asg-launch-db-"
  image_id      = "ami-0cf5ecd839872ea62"
  instance_type = "t2.micro"
  key_name = aws_key_pair.generated_key_pair.key_name
  security_groups = ["${aws_security_group.security.id}"]

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_policy" "scaling_policy" {
  name = "auto-scaling-policy-for-ec2-webserver"
  
  adjustment_type = "TargetTrackingScaling"
  policy_type = "TargetTrackingScaling"

  autoscaling_group_name = aws_autoscaling_group.asg_public.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 80.0
  }
}

resource "aws_autoscaling_group" "asg_public" {
  name                 = "asg_public"
  launch_configuration = aws_launch_configuration.launch_conf_frontend.name
  min_size             = 1
  max_size             = 2

  target_group_arns = [aws_lb_target_group.frontendtg.arn]
  vpc_zone_identifier = [aws_subnet.public_subnet1.id,  aws_subnet.public_subnet2.id]

  tag {
    key                 = "Key"
    value               = "Value"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "asg_private" {
  name                 = "asg_private"
  launch_configuration = aws_launch_configuration.launch_conf_db_servers.name
  min_size             = 1
  max_size             = 2

  target_group_arns = [aws_lb_target_group.frontendtg.arn]
  vpc_zone_identifier = [aws_subnet.private_subnet1.id,  aws_subnet.private_subnet2.id]
  
  tag {
    key                 = "Key"
    value               = "Value"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

