output "alb_arn" {
  value = aws_lb.cors-alb.arn
}

output "alb_dns_name" {
  value = aws_lb.cors-alb.dns_name
}
output "alb_listener" {
  value = aws_lb_listener.cors-listener.arn
}