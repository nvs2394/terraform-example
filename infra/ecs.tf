# ecs.tf | Elastic Container Service Configuration

resource "aws_ecs_cluster" "aws-ecs-cluster" {
  name = "${var.app_name}-${var.app_environment}-cluster"
  tags = {
    Name        = "${var.app_name}-ecs"
    Environment = var.app_environment
  }
}


# log.tf | CloudWatch Log Configuration
resource "aws_cloudwatch_log_group" "log-group" {
  name = "${var.app_name}-${var.app_environment}-logs"

  tags = {
    Application = var.app_name
    Environment = var.app_environment
  }
}

# ecs_task_definition | ECS Task Definition Configuration

data "template_file" "env_vars" {
  template = file("env_vars.json")
}

resource "aws_ecs_task_definition" "aws-ecs-task" {
  family = "${var.app_name}-task"

  container_definitions = <<DEFINITION
  [
    {
      "name": "${var.app_name}-${var.app_environment}-container",
      "image": "${aws_ecr_repository.aws-ecr.repository_url}:latest",
      "entryPoint": [],
      "environment": [
      {"name": "NODE_ENV", "value": "production"}
      ],
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.log-group.id}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "${var.app_name}-${var.app_environment}"
        }
      },
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080
        }
      ],
      "cpu": 256,
      "memory": 512,
      "networkMode": "awsvpc"
    }
  ]
  DEFINITION

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn

  tags = {
    Name        = "${var.app_name}-ecs-td"
    Environment = var.app_environment
  }
}

data "aws_ecs_task_definition" "main" {
  task_definition = aws_ecs_task_definition.aws-ecs-task.family
}

# ecs-service.tf | ECS Service Configuration

resource "aws_ecs_service" "aws-ecs-service" {
  name                 = "${var.app_name}-${var.app_environment}-ecs-service"
  cluster              = aws_ecs_cluster.aws-ecs-cluster.id
  task_definition      = "${aws_ecs_task_definition.aws-ecs-task.family}:${max(aws_ecs_task_definition.aws-ecs-task.revision, data.aws_ecs_task_definition.main.revision)}"
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true

  network_configuration {
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
    security_groups = [
      aws_security_group.service_security_group.id,
      aws_security_group.load_balancer_security_group.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "${var.app_name}-${var.app_environment}-container"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.listener]
}

resource "aws_security_group" "service_security_group" {
  vpc_id = aws_vpc.aws-vpc.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.load_balancer_security_group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.app_name}-service-sg"
    Environment = var.app_environment
  }
}

# alb.tf | Application Load Balancer

resource "aws_alb" "application_load_balancer" {
  name               = "${var.app_name}-${var.app_environment}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.load_balancer_security_group.id]

  tags = {
    Name        = "${var.app_name}-alb"
    Environment = var.app_environment
  }
}
# alb_securitygroup.tf | Application Load Balancer Security Group

resource "aws_security_group" "load_balancer_security_group" {
  vpc_id = aws_vpc.aws-vpc.id

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name        = "${var.app_name}-sg"
    Environment = var.app_environment
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "${var.app_name}-${var.app_environment}-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.aws-vpc.id

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/v1/status"
    unhealthy_threshold = "2"
    port = "8080"
  }

  tags = {
    Name        = "${var.app_name}-lb-tg"
    Environment = var.app_environment
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.id
  port              = "80"
  protocol          = "HTTP"

  # default_action {
  #   type = "redirect"

  #   redirect {
  #     port        = "443"
  #     protocol    = "HTTPS"
  #     status_code = "HTTP_301"
  #   }
  # }

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}

# resource "aws_lb_listener" "listener-https" {
#   load_balancer_arn = aws_alb.application_load_balancer.id
#   port              = "443"
#   protocol          = "HTTPS"

#   ssl_policy      = "ELBSecurityPolicy-2016-08"
#   certificate_arn = "<certificate-arn>"

#   default_action {
#     target_group_arn = aws_lb_target_group.target_group.id
#     type             = "forward"
#   }
# }
