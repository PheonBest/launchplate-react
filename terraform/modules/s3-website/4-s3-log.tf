# Logging bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = "${local.prefix}-log"

  tags = var.tags
}

# Encryption for log bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "log_bucket_encryption" {
  count = var.enable_encryption ? 1 : 0

  bucket = aws_s3_bucket.log_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.enable_encryption ? aws_kms_key.shared[0].arn : null
      sse_algorithm     = var.enable_encryption ? "aws:kms" : "AES256"
    }
  }
}



# Public access block for log bucket (same settings)
resource "aws_s3_bucket_public_access_block" "log_public_access" {
  bucket = aws_s3_bucket.log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
# Use bucket policy instead of ACLs to:
# - Allow S3 buckets to send logs
# - Allow Cloudflare to send logs
data "aws_caller_identity" "current" {}

# To allow CloudFront distribution to send logs to the log bucket,
# ACLs must be enabled since april 2023
resource "aws_s3_bucket_ownership_controls" "log_bucket_ownership" {
  bucket = aws_s3_bucket.log_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_policy" "log_bucket_policy" {
  bucket = aws_s3_bucket.log_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.log_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "aws:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/*"
          }
        }
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "logging.s3.amazonaws.com"
        }
        Action = [
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.log_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
            "aws:SourceArn" = var.enable_failover_s3 ? [
              aws_s3_bucket.primary.arn,
              aws_s3_bucket.failover["enabled"].arn
              ] : [
              aws_s3_bucket.primary.arn
            ]
          }
        }
      }
    ]
  })
}

# Bucket logging for primary bucket
resource "aws_s3_bucket_logging" "this" {
  bucket        = aws_s3_bucket.primary.id
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/primary/"
}

# Bucket logging for failover bucket
resource "aws_s3_bucket_logging" "failover" {
  for_each = var.enable_failover_s3 ? { "enabled" = true } : {}

  bucket        = aws_s3_bucket.failover["enabled"].id
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/failover/"
}
