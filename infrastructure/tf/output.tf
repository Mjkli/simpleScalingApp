output "lb_url" {
    value = aws_lb.main_lb.dns_name
}

output "cf_public_url" {
    value = aws_cloudfront_distribution.s3_distrib.domain_name
}