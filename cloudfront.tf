resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "OAI"
}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    origin_id   = "S3-${var.bucket_name}"
    domain_name = "${var.bucket_name}.s3.amazonaws.com"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }
  # If using route53 aliases for DNS we need to declare it here too, otherwise we'll get 403s.
  aliases = [var.bucket_name]

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${var.bucket_name}"

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  # This is required to be specified even if it's not used.
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    # CloudFront serves your content over HTTPS to clients that support SNI (Server Name Indication).
    # SNI is supported by browsers and clients released after 2010. There is no additional charge for this option.
    ssl_support_method = "sni-only"
  }

  tags = var.tags
  #checkov:skip=CKV_AWS_68:CloudFront Distribution should have WAF enabled
  #checkov:skip=CKV_AWS_86:Ensure Cloudfront distribution has Access Logging enabled
}
