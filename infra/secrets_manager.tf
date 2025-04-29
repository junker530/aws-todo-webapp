# ---------------------------------------------
# Secrets Manager
# ---------------------------------------------
resource "aws_secretsmanager_secret" "mysql" {
  name                    = "${var.project}-${var.environment}-mysql-secret"
  description             = "MySQL credentials for ${var.project}-${var.environment}"
  recovery_window_in_days = 0

  tags = {
    Name = "${var.project}-${var.environment}-mysql-secret"
  }
}

resource "aws_secretsmanager_secret_version" "mysql" {
  secret_id = aws_secretsmanager_secret.mysql.id
  secret_string = jsonencode({
    username = var.mysql_username
    password = var.mysql_password
    database = var.mysql_database
    hostname = aws_db_instance.mysql.address
  })
}
