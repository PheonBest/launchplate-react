variable "project_name" {
  description = "Project name"
  type        = string
  default     = "launchplate-react"
}

variable "enable_failover_s3" {
  type        = map(bool)
  description = "Enable failover S3 bucket"
  default = {
    prod = true
    stg  = false
    dev  = false
  }
}

variable "enable_waf" {
  type        = map(bool)
  description = "Enable Web Application Firewall"
  default = {
    prod = false
    stg  = false
    dev  = false
  }
}

variable "region" {
  description = "AWS Region"
  type        = map(string)
  default = {
    prod = "eu-west-3"
    stg  = "eu-west-3"
    dev  = "eu-west-3"
  }
}

variable "base_domain" {
  description = "Base Domain Name"
  type        = map(string)
  default = {
    prod = "gloweet.com"
    stg  = "gloweet.com"
    dev  = "gloweet.com"
  }
}
variable "domain_name" {
  description = "Domain Name"
  type        = map(string)
  default = {
    prod = "launchplate-react.gloweet.com"
    stg  = "stg-launchplate-react.gloweet.com"
    dev  = "dev-launchplate-react.gloweet.com"
  }
}

variable "subject_alternative_names" {
  description = "Domain Name"
  type        = map(list(string))
  default = {
    prod = ["www.launchplate-react.gloweet.com"]
    stg  = ["www.stg-launchplate-react.gloweet.com"]
    dev  = ["www.dev-launchplate-react.gloweet.com"]
  }
}

variable "aliases" {
  description = "CloudFront Aliases"
  type        = map(list(string))
  default = {
    prod = ["launchplate-react.gloweet.com", "www.launchplate-react.gloweet.com"]
    stg  = ["stg-launchplate-react.gloweet.com", "www.stg-launchplate-react.gloweet.com"]
    dev  = ["dev-launchplate-react.gloweet.com", "www.dev-launchplate-react.gloweet.com"]
  }
}

variable "dns_provider" {
  description = "DNS Provider"
  type        = map(string)
  validation {
    condition     = alltrue([for v in var.dns_provider : contains(["cloudflare", "route53"], v)])
    error_message = "dns_provider must be either 'cloudflare' or 'route53'"
  }
  default = {
    prod = "cloudflare"
    stg  = "cloudflare"
    dev  = "cloudflare"
  }
}

variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  type        = map(string)
  sensitive   = true
}

variable "zone_name" {
  description = "Cloudflare/Route53 zone name"
  type        = map(string)
  default = {
    prod = "gloweet.com"
    stg  = "gloweet.com"
    dev  = "gloweet.com"
  }
}

variable "environment_specific_tag" {
  description = "Environment specific tags"
  type        = map(map(string))
  default = {
    prod = {}
    stg  = {}
    dev  = {}
  }
}
