# Primary origin bucket
resource "aws_s3_bucket" "primary" {
  bucket        = "${local.prefix}-primary"
  force_destroy = false

  tags = var.tags
}

# Encryption
resource "aws_kms_key" "shared" {
  count = var.enable_encryption ? 1 : 0

  is_enabled          = true
  enable_key_rotation = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "primary_encryption_configuration" {
  count = var.enable_encryption ? 1 : 0

  bucket = aws_s3_bucket.primary.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.enable_encryption ? aws_kms_key.shared[0].arn : null
      sse_algorithm     = var.enable_encryption ? "aws:kms" : "AES256"
    }
  }
}

# Public access block for primary bucket
resource "aws_s3_bucket_public_access_block" "primary_public_access" {
  bucket = aws_s3_bucket.primary.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Website config for primary bucket
resource "aws_s3_bucket_website_configuration" "primary" {
  bucket = aws_s3_bucket.primary.id

  index_document {
    suffix = var.index_document
  }
}
