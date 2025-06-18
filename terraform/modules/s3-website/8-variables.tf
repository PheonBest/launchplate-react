variable "acm_certificate" {
  description = "The ARN of the ACM certificate"
  type = string
  nullable = true
}

variable "aliases" {
  description = "The aliases for the CloudFront distribution"
  type        = list(string)
  nullable = true
}

variable "region" {
  description = "The AWS region"
  type        = string
}

variable "enable_failover_s3" {
  description = "If true, deploy a failover S3 bucket"
  type        = bool
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}


variable "price_class" {
  description = "The price class for the CloudFront distribution"
  type        = string
  default     = "PriceClass_100"
}

variable "index_document" {
  description = "The index document of the website"
  type        = string
  default     = "index.html"
}

variable "html_source_dir" {
  description = "Directory path for HTML source files"
  type        = string
  default     = "static/html/"
}

variable "enable_ruleset_ip_reputation" {
  description = "Enable AWS Managed Rules IP Reputation List"
  type        = bool
  default     = false
}

variable "enable_ruleset_common" {
  description = "Enable AWS Managed Rules Common Rule Set"
  type        = bool
  default     = false
}

variable "enable_ruleset_known_bad_inputs" {
  description = "Enable AWS Managed Rules Known Bad Inputs Rule Set"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Resource tags"
  type = map(string)
  default = {}
}