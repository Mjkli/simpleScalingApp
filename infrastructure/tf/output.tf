output "lb_url" {
    value = aws_lb.main_lb.dns_name
}

output "s3_public_url" {
    value = aws_s3_bucket_website_configuration.example.website_endpoint
}