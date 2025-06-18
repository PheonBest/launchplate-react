output "s3_bucket_url" {
  description = "The website URL of the S3 bucket"
  value       = "http://${aws_s3_bucket.primary.bucket}.s3-website.${var.region}.amazonaws.com"
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket hosting the website"
  value       = aws_s3_bucket.primary.bucket
}

output "s3_failover_bucket_url" {
  description = "The website URL of the S3 failover bucket hosting the website"
  value       = var.enable_failover_s3 ? "http://${aws_s3_bucket.failover["enabled"].bucket}.s3-website.${var.region}.amazonaws.com" : null
}

output "cloudfront_distribution_domain" {
  value = aws_cloudfront_distribution.this.domain_name
}
