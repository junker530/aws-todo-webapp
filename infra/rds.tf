# ---------------------------------------------
# RDS for MySQL
# ---------------------------------------------
resource "aws_db_instance" "mysql" {
  identifier        = "${var.project}-${var.environment}-mysql-rds"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = var.mysql_database
  username = var.mysql_username
  password = var.mysql_password

  vpc_security_group_ids = [aws_security_group.database.id]
  db_subnet_group_name   = aws_db_subnet_group.mysql.name
  parameter_group_name   = aws_db_parameter_group.mysql.name

  deletion_protection = false
  skip_final_snapshot = true
  apply_immediately   = true
  multi_az            = false

  tags = {
    Name = "${var.project}-${var.environment}-mysql-rds"
  }
}

resource "aws_db_subnet_group" "mysql" {
  name       = "${var.project}-${var.environment}-mysql-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "${var.project}-${var.environment}-mysql-subnet-group"
  }
}

resource "aws_db_parameter_group" "mysql" {
  name        = "${var.project}-${var.environment}-mysql-parameter-group"
  family      = "mysql8.0"
  description = "MySQL parameter group for ${var.project}-${var.environment}"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_server"
    value = "utf8mb4_unicode_ci"
  }

  parameter {
    apply_method = "pending-reboot"
    name         = "lower_case_table_names"
    value        = "0"
  }

  parameter {
    name  = "require_secure_transport"
    value = "0"
  }

  parameter {
    name  = "time_zone"
    value = "Asia/Tokyo"
  }


  tags = {
    Name = "${var.project}-${var.environment}-mysql-parameter-group"
  }
}