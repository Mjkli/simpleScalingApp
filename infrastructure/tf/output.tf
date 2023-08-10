output "lb_url" {
    value = aws_lb.main_lb.dns_name
}