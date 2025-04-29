# ---------------------------------------------
# Policy
# ---------------------------------------------
resource "aws_iam_policy" "secretsmanager_read" {
  name        = "${var.project}-${var.environment}-secretsmanager-read-policy"
  description = "Allow read access to Secrets Manager"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "kms:Decrypt",
        ]
        Resource = "*"
      }
    ]
  })
}

# ---------------------------------------------
# IAM Role
# ---------------------------------------------
resource "aws_iam_role" "ecs_exec" {
  name = "${var.project}-${var.environment}-ecs-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.project}-${var.environment}-ecs-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_exec_task_execution" {
  role       = aws_iam_role.ecs_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_exec_secretsmanager_read" {
  role       = aws_iam_role.ecs_exec.name
  policy_arn = aws_iam_policy.secretsmanager_read.arn
}


# ---------------------------------------------
# CloudWatch Log Group
# ---------------------------------------------
resource "aws_cloudwatch_log_group" "webapp" {
  name              = "/ecs/${var.project}/${var.environment}/webapp"
  retention_in_days = 7
  tags = {
    Name = "${var.project}-${var.environment}-ecs-execution-webapp-log-group"
  }
}

# ---------------------------------------------
# ECS
# ---------------------------------------------
resource "aws_ecs_cluster" "main" {
  name = "${var.project}-${var.environment}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  tags = {
    Name = "${var.project}-${var.environment}-ecs-cluster"
  }
}

resource "aws_ecs_task_definition" "webapp" {
  family                   = "${var.project}-${var.environment}-ecs-webapp-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_exec.arn

  container_definitions = jsonencode([
    {
      name      = "webapp"
      image     = "${aws_ecr_repository.webapp.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        },
      ]
      secrets = [
        {
          name      = "MYSQL_HOST"
          valueFrom = "${aws_secretsmanager_secret.mysql.arn}:hostname::"
        },
        {
          name      = "MYSQL_USER"
          valueFrom = "${aws_secretsmanager_secret.mysql.arn}:username::"
        },
        {
          name      = "MYSQL_PASSWORD"
          valueFrom = "${aws_secretsmanager_secret.mysql.arn}:password::"
        },
        {
          name      = "MYSQL_DATABASE"
          valueFrom = "${aws_secretsmanager_secret.mysql.arn}:database::"
        }
      ]
      environment = [
        {
          name  = "MYSQL_SSL"
          value = "false"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.webapp.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "${var.project}-${var.environment}-ecs-task-definition-webapp"
  }
}

resource "aws_ecs_service" "webapp" {
  name            = "${var.project}-${var.environment}-ecs-webapp-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.webapp.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.private[*].id
    security_groups  = [aws_security_group.webapp.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs.arn
    container_name   = "webapp"
    container_port   = 3000
  }

  tags = {
    Name = "${var.project}-${var.environment}-ecs-webapp-service"
  }
}