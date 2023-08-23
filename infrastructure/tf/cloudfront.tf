resource "aws_cloudfront_origin_access_control" "cf_s3_oac" {
    name                              = "cf s3 OAC"
    origin_access_control_origin_type = "s3"
    signing_behavior                  = "always"
    signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distrib" {
    default_root_object = "main.html"
    enabled = true

    origin {
        domain_name = aws_s3_bucket.ssa-web.bucket_regional_domain_name
        origin_id = "ssa-s3"
        origin_access_control_id = aws_cloudfront_origin_access_control.cf_s3_oac.id
    }

    default_cache_behavior {
        allowed_methods = ["GET","HEAD","OPTIONS"]
        cached_methods  = ["GET","HEAD"]
        target_origin_id = "ssa-s3"

        forwarded_values {
            query_string = false
            cookies {
                forward = "none"
            }
        }
        viewer_protocol_policy = "redirect-to-https"
        ### These options determine how long the files should be cached at each location ###
        min_ttl                = 0
        default_ttl            = 0
        max_ttl                = 0
    }

    viewer_certificate {
        cloudfront_default_certificate = true
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
            locations = []
        }
    }

}