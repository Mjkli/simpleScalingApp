resource "aws_s3_bucket" "ssa-web"{
    bucket = "mjkli-ssa-web"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.ssa-web.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.ssa-web.id
  rule{
    object_ownership = "BucketOwnerPreferred"
  }

}

resource "aws_s3_bucket_website_configuration" "example" {
    bucket = aws_s3_bucket.ssa-web.id

    index_document {
        suffix = "index.html"
    }
}

data "aws_iam_policy_document" "allow_public_access" {
    statement {
      principals {
        type = "*"
        identifiers = ["*"]
      }
      actions = [
        "s3:GetObject",
        "s3:ListBucket"
      ]
      resources = [
        aws_s3_bucket.ssa-web.arn,
        "${aws_s3_bucket.ssa-web.arn}/*"
      ]
    }

}

resource "aws_s3_bucket_policy" "allow_access_from_public"{
    bucket = aws_s3_bucket.ssa-web.id
    policy = data.aws_iam_policy_document.allow_public_access.json
}

resource "aws_s3_object" "webpages" {
  for_each = fileset("web/","*")
  bucket = aws_s3_bucket.ssa-web.id
  key = each.value
  source = "web/${each.value}"
  etag = filemd5("web/${each.value}")
  content_type = "text/html"

}
