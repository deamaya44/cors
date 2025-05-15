resource "aws_lb" "cors-alb" {
  name                       = "${var.name}-alb"
  internal                   = var.internal
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb_sg.id]
  subnets                    = var.private_subnets
  enable_deletion_protection = false
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.name}-alb_sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_listener" "cors-listener" {
  load_balancer_arn = aws_lb.cors-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "hola"
      status_code  = "200"
    }
  }
}
