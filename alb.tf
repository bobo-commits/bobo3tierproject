# Create Application Load Balancer
# This resource creates an Application Load Balancer (ALB) in AWS.
resource "aws_lb" "cloudswitch360_project_alb" {
  name               = "cloudswitch360-project-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group.id]

  enable_deletion_protection = false
  subnet_mapping {
    subnet_id = aws_subnet.cloudswitch360_project_public_subnet-az1a.id
  }
  tags = {
    Name = "cloudswitch360_project_alb"
  }
}

# create target group
resource "aws_lb_target_group" "cloudswitch360_project_app_target_group" {
  name        = "cloudswitch360-project-app-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.cloudswitch360_project_vpc.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# Register the jupiter server with the target group
resource "aws_lb_target_group_attachment" "jupiter_server" {
  target_group_arn = aws_lb_target_group.cloudswitch360_project_app_target_group.arn
  target_id        = aws_instance.jupiter_server.id
}

#create a listener on port 80 with redirect action
resource "aws_lb_listener" "cloudswitch360_project_alb_listener" {
  load_balancer_arn = aws_lb.cloudswitch360_project_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      host        = "#{host}"
      path        = "/"
      port        = "443"
      protocol    = "HTTPS"
      query       = "#{query}"
      status_code = "HTTP_301"
    }
  }
}
#create a listener on port 443 with forward action (HTTPS)
resource "aws_lb_listener" "cloudswitch360_project_alb_https_listener" {
  load_balancer_arn = aws_lb.cloudswitch360_project_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cloudswitch360_project_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cloudswitch360_project_app_target_group.arn
  }
}
