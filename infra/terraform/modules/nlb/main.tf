resource "aws_lb" "cors-nlb" {
  name                       = "${var.name}-nlb"
  internal                   = true
  load_balancer_type         = "network"
  subnets                    = var.private_subnets
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "nlb_tg" {
  name        = "${var.name}-nlb-tg"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "alb" # Se usará la IP del ALB

  health_check {
    protocol            = "HTTP"
    port                = "80"
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "nlb_to_alb" {
  target_group_arn = aws_lb_target_group.nlb_tg.arn
  target_id        = var.alb_arn # Registra el ALB como backend
  port             = 80
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.cors-nlb.arn
  protocol          = "TCP"
  port              = 80

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg.arn
  }
}
resource "aws_api_gateway_vpc_link" "vpc_link" {
  name = "global-vpc-link"
  target_arns = [
    aws_lb.cors-nlb.arn
  ]
}