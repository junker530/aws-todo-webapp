# ------------------------------------
# Security group
# ------------------------------------
# Frontend security group
# ------------------------------------
resource "aws_security_group" "frontend" {
  name        = "${var.project}-${var.environment}-frontend-sg"
  vpc_id      = aws_vpc.main.id
  description = "Allow HTTP and HTTPS traffic to the frontend, and all outbound traffic"
  tags = {
    Name = "${var.project}-${var.environment}-fronend-sg"
  }
}

resource "aws_security_group_rule" "frontend_in_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.frontend.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "frontend_in_https" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  security_group_id = aws_security_group.frontend.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "frontend_out_all" {
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  security_group_id = aws_security_group.frontend.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# ------------------------------------
# Webapp security group
# ------------------------------------
resource "aws_security_group" "webapp" {
  name        = "${var.project}-${var.environment}-webapp-sg"
  vpc_id      = aws_vpc.main.id
  description = "Allow tcp3000 traffic to the webapp, and all outbound traffic"
  tags = {
    Name = "${var.project}-${var.environment}-webapp-sg"
  }
}

resource "aws_security_group_rule" "webapp_in_tcp3000" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3000
  to_port           = 3000
  security_group_id = aws_security_group.webapp.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "webapp_out_all" {
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  security_group_id = aws_security_group.webapp.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# ------------------------------------
# Database security group
# ------------------------------------
resource "aws_security_group" "database" {
  name        = "${var.project}-${var.environment}-database-sg"
  vpc_id      = aws_vpc.main.id
  description = "Allow tcp3306 inbound traffic from webapp security group."
  tags = {
    Name = "${var.project}-${var.environment}-database-sg"
  }
}

resource "aws_security_group_rule" "database_in_tcp3306" {
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  security_group_id        = aws_security_group.database.id
  source_security_group_id = aws_security_group.webapp.id
}

# ------------------------------------
# VPC Endpoint security group
# ------------------------------------
resource "aws_security_group" "vpc_endpoint" {
  name        = "${var.project}-${var.environment}-vpc-endpoint-sg"
  vpc_id      = aws_vpc.main.id
  description = "Allow HTTPS inbound traffic, and HTTPS outbound traffic"
  tags = {
    Name = "${var.project}-${var.environment}-vpc-endpoint-sg"
  }
}

resource "aws_security_group_rule" "vpcep_in_https" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  security_group_id = aws_security_group.vpc_endpoint.id
  cidr_blocks       = [aws_vpc.main.cidr_block]
}

resource "aws_security_group_rule" "vpcep_out_https" {
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  security_group_id = aws_security_group.vpc_endpoint.id
  cidr_blocks       = [aws_vpc.main.cidr_block]
} 