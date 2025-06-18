# Failover bucket
resource "aws_s3_bucket" "failover" {
  for_each = var.enable_failover_s3 ? { "enabled" = true } : {}

  bucket        = "${local.prefix}-failover"
  force_destroy = false

  tags = var.tags
}

# Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "failover" {
  for_each = var.enable_failover_s3 ? { "enabled" = true } : {}

  bucket = aws_s3_bucket.failover["enabled"].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.shared.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Public access block for failover bucket (same settings)
resource "aws_s3_bucket_public_access_block" "failover" {
  for_each = var.enable_failover_s3 ? { "enabled" = true } : {}

  bucket = aws_s3_bucket.failover["enabled"].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Website config for failover bucket
resource "aws_s3_bucket_website_configuration" "failover" {
  for_each = var.enable_failover_s3 ? { "enabled" = true } : {}

  bucket = aws_s3_bucket.failover["enabled"].id

  index_document {
    suffix = var.index_document
  }
}