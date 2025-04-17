#create security group for the application load balancer
#terraform aws create SG
resource "aws_security_group" "alb_security_group" {
  name        = "alb_security_group"
  description = "enable http/https access on port 80/443"
  vpc_id      = var.vpc_cidr

  ingress {
    description = "allow http acccess to the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow https acccess to the internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cloudswitch360_project_alb_sg"
  }
}

#create SG for the web server
#terraform aws create SG
resource "aws_security_group" "cloudswitch360_jupiter_web_sg" {
  name        = "cloudswitch360_jupiter_web_sg"
  description = "Allow internet access to the web server http port 80"
  vpc_id      = aws_vpc.cloudswitch360_project_vpc.id

  ingress {
    description = "allow http acccess to the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [
      aws_security_group.alb_security_group.id
    ]
  }

  ingress {
    description = "allow https acccess to the internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [
      aws_security_group.alb_security_group.id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "cloudswitch360_jupiter_web_sg"
  }
}