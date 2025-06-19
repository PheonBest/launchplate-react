variable "dns_provider" {
  description = "The DNS provider to use for validation (cloudflare or route53)"
  type        = string
  validation {
    condition     = contains(["cloudflare", "route53"], var.dns_provider)
    error_message = "dns_provider must be either 'cloudflare' or 'route53'"
  }
  nullable = false
}

variable "base_domain" {
  description = "Base Domain Name"
  type        = string
  nullable    = false
}

variable "redirect_root_to_www" {
  description = "[Cloudflare] Whether to redirect root domain to www"
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "A domain name for which the DNS record should be created"
  type        = string
  nullable    = false
}

variable "subject_alternative_names" {
  description = "A list of domains that should also have DNS records. If redirect_root_to_www is true, ignore this parameter"
  type        = list(string)
  default     = []
}

variable "zone_name" {
  description = "The name of the Cloudflare/Route53 zone to contain this record."
  type        = string
  nullable    = false
}

variable "cloudfront_domain_name" {
  description = "The CloudFront distribution domain name"
  type        = string
  nullable    = false
}

variable "cloudfront_hosted_zone_id" {
  description = "The CloudFront distribution hosted zone ID"
  type        = string
  default     = "Z2FDTNDATAQYW2" # CloudFront hosted zone ID (always the same)
}

variable "proxied" {
  description = "Whether to proxy the Cloudflare DNS record"
  type        = bool
  default     = false
}

variable "dns_ttl" {
  description = "The TTL of DNS recursive resolvers to cache information about this record."
  type        = number
  default     = 120
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
