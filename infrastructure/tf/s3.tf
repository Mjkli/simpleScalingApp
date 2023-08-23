resource "aws_s3_bucket" "ssa-web"{
    bucket = "mjkli-ssa-web"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.ssa-web.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.ssa-web.id
  rule{
    object_ownership = "BucketOwnerPreferred"
  }

}

data "aws_iam_policy_document" "allow_cloudfront" {
    statement {
      principals {
        type = "Service"
        identifiers = ["cloudfront.amazonaws.com"]
      }
      actions = [
        "s3:GetObject"
      ]
      resources = [
        "${aws_s3_bucket.ssa-web.arn}/*"
      ]
      condition {
        test = "StringEquals"
        variable = "AWS:SourceArn"
        values = [aws_cloudfront_distribution.s3_distrib.arn]
      }
    }

}

resource "aws_s3_bucket_policy" "allow_access_from_public"{
    bucket = aws_s3_bucket.ssa-web.id
    policy = data.aws_iam_policy_document.allow_cloudfront.json
}

resource "aws_s3_object" "webpages" {
  for_each = fileset("../../web/","*")
  bucket = aws_s3_bucket.ssa-web.id
  key = each.value
  source = "../../web/${each.value}"
  etag = filemd5("../../web/${each.value}")
  content_type = "text/html"

}
