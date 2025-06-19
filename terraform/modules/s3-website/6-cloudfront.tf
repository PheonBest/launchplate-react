locals {
  s3_origin_id = "${local.prefix}-s3-origin"
}

resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "OAI for ${var.project_name} in environment ${var.env}"
}

# Create policies to allow OAI to retrieve objects from S3 buckets
data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.primary.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn]
    }
  }
}
data "aws_iam_policy_document" "s3_failover_policy" {
  for_each = var.enable_failover_s3 ? { "enabled" = true } : {}

  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.failover[each.key].arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn]
    }
  }
}

# Assign policies to OAI
resource "aws_s3_bucket_policy" "primary_bucket_policy" {
  depends_on = [aws_s3_bucket.primary, aws_s3_bucket_website_configuration.primary]
  bucket     = aws_s3_bucket.primary.id
  policy     = data.aws_iam_policy_document.s3_policy.json
}
resource "aws_s3_bucket_policy" "failover_bucket_policy" {
  depends_on = [aws_s3_bucket.failover, aws_s3_bucket_website_configuration.failover]
  for_each   = data.aws_iam_policy_document.s3_failover_policy

  bucket = aws_s3_bucket.failover[each.key].id
  policy = each.value.json
}

# Setup cache with CloudFront distribution
resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  is_ipv6_enabled     = true
  web_acl_id          = var.enable_waf ? aws_wafv2_web_acl.this["enabled"].arn : null
  default_root_object = var.index_document
  price_class         = var.price_class
  aliases             = var.acm_certificate == null ? null : var.aliases
  tags                = var.tags

  # Custom error responses for SPA routing
  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  # Origin group for failover (optional)
  dynamic "origin_group" {
    for_each = var.enable_failover_s3 ? [1] : []

    content {
      origin_id = "${local.s3_origin_id}-group"

      failover_criteria {
        status_codes = [403, 404, 500, 502]
      }

      member {
        origin_id = local.s3_origin_id
      }

      member {
        origin_id = "${local.s3_origin_id}-failover"
      }
    }
  }

  # Primary origin
  origin {
    domain_name = aws_s3_bucket.primary.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  # Failover origin (optional)
  dynamic "origin" {
    for_each = var.enable_failover_s3 ? [1] : []

    content {
      domain_name = aws_s3_bucket.failover["enabled"].bucket_regional_domain_name
      origin_id   = "${local.s3_origin_id}-failover"

      s3_origin_config {
        origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
      }
    }
  }

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.log_bucket.bucket_domain_name
    prefix          = "cloudfront/"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.enable_failover_s3 ? "${local.s3_origin_id}-group" : local.s3_origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate
    cloudfront_default_certificate = var.acm_certificate == null ? true : false
    ssl_support_method             = var.acm_certificate == "" ? null : "sni-only"
    minimum_protocol_version       = var.acm_certificate == "" ? null : "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
