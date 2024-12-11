# Load Balancer
resource "aws_lb" "app" {
  name               = "utc-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets

  tags = {
    Name = "utc-alb"
    env  = "dev"
    team = "config management"
  }
}

resource "aws_lb_target_group" "app" {
  name        = "utc-target-group-${random_string.suffix.id}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "utc-target-group"
    env  = "dev"
    team = "config management"
  }
}

resource "random_string" "suffix" {
  length  = 4
  special = false
}


# Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

# Target Group Attachments
resource "aws_lb_target_group_attachment" "app" {
  count            = length(aws_instance.app_server)
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.app_server[count.index].id
  port             = 80
}

