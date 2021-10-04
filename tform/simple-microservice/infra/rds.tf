resource "aws_db_subnet_group" "Db-Subnet-Group" {
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.db_private_subnet1.id, aws_subnet.db_private_subnet2.id]

  tags = {
    Name = "Subnet groups to be used with rds"
  }
}

resource "aws_db_subnet_group" "Replica-Db-Subnet-Group" {
  name       = "replica-db-subnet-group"
  subnet_ids = [aws_subnet.db_private_subnet1.id, aws_subnet.db_private_subnet2.id]

  tags = {
    Name = "Subnet groups to be used with rds"
  }
}

resource "aws_db_instance" "Rds-Db" {
    allocated_storage    = 10
    engine               = "mysql"
    engine_version       = "5.7"
    instance_class       = "db.t3.micro"
    name                 = "test"
    vpc_security_group_ids = [aws_security_group.security.id]
    availability_zone = var.db_az1
    username             = var.db_username
    port = var.db_port
    db_subnet_group_name = aws_db_subnet_group.Db-Subnet-Group.name
    password             = var.db_password
    parameter_group_name = "default.mysql5.7"
    skip_final_snapshot  = true
    backup_retention_period = 5
    apply_immediately = true
}

resource "aws_db_instance" "Rds-Db-Replica" {
    identifier         = "replica"
    replicate_source_db = aws_db_instance.Rds-Db.identifier ## change to arn if sournce and replica databases are in different region.
    allocated_storage    = 10
    instance_class       = "db.t3.micro"
    name                 = "test"
    vpc_security_group_ids = [aws_security_group.security.id]
    availability_zone = var.db_az2
    port = var.db_port
    skip_final_snapshot  = true
    parameter_group_name = "default.mysql5.7"
    apply_immediately = true
}