# Create Application Load Balancer
# This resource creates an Application Load Balancer (ALB) in AWS.
resource "aws_lb" "application_load_balancer" {
  name               = "bustercloud-project-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group.id]

  enable_deletion_protection = false
  subnet_mapping {
    subnet_id = aws_subnet.bustercloud_project_public_subnet-az1a.id
  }
  subnet_mapping {
    subnet_id = aws_subnet.bustercloud_project_public_subnet-az1b.id
  }
  tags = {
    Name = "application-load-balancer"
  }
}

# create target group
resource "aws_lb_target_group" "alb_target_group" {
  name        = "bustercloud-jupiter-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.bustercloud_project_vpc.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200,301,302"
  }
}

# Register the jupiter server with the target group
resource "aws_lb_target_group_attachment" "jupiter_web_target_group_attachment" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = aws_instance.bustercloud_jupiter_web.id
  port             = 80
}

#create a listener on port 80 with redirect action
resource "aws_lb_listener" "bustercloud_project_alb_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      host        = "#{host}"
      path        = "/"
      port        = 443
      protocol    = "HTTPS"
      query       = "#{query}"
      status_code = "HTTP_301"
    }
  }
}
#create a listener on port 443 with forward action (HTTPS)
resource "aws_lb_listener" "alb_https_listener" {
  # This resource creates a listener for the Application Load Balancer (ALB) on port 443 with HTTPS protocol.
  # It uses the SSL certificate created in the acm.tf file for secure communication.
  # The listener forwards traffic to the target group created in the previous step.
  # The default action is to forward the traffic to the target group.
  # The listener is associated with the ALB created in the previous step.
  # The listener uses the SSL certificate created in the acm.tf file for secure communication.
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.ssl_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}
