# ------------------------------------
# Application Load Balancer
# ------------------------------------
resource "aws_lb" "frontend" {
  name               = "${var.project}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.frontend.id]
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = false

  tags = {
    Name = "${var.project}-${var.environment}-alb"
  }
}

resource "aws_lb_target_group" "ecs" {
  name        = "${var.project}-${var.environment}-alb-ecs-tg"
  protocol    = "HTTP"
  target_type = "ip"
  port        = 3000
  vpc_id      = aws_vpc.main.id

  health_check {
    path     = "/"
    protocol = "HTTP"
    port     = "traffic-port"
    interval = 30
    timeout  = 5
  }

  tags = {
    Name = "${var.project}-${var.environment}-alb-ecs-tg"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.frontend.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs.arn
  }

  tags = {
    Name = "${var.project}-${var.environment}-alb-http-listener"
  }
}
