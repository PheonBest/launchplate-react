# Route records for CloudFront distribution
# Creates either Cloudflare DNS records or Route53 records based on dns_provider

# Cloudflare records
resource "cloudflare_dns_record" "this" {
  for_each = local.use_cloudflare ? toset(local.distinct_domain_names_without_base) : []

  zone_id = data.cloudflare_zone.this[0].zone_id
  name    = each.value == "" ? "@" : each.value
  type    = "CNAME"
  content = var.cloudfront_domain_name
  ttl     = var.dns_ttl
  proxied = var.proxied
}

resource "cloudflare_dns_record" "proxied_route" {
  for_each = local.use_cloudflare && var.redirect_root_to_www ? { "enabled" : true } : {}

  zone_id = data.cloudflare_zone.this[0].zone_id
  name    = local.domain_name_without_base == "" ? "@" : local.domain_name_without_base
  type    = "A"
  content = "192.0.2.1" # Will be overwritten by Cloudflare Page Rule
  ttl     = 1
  proxied = true
}

resource "cloudflare_page_rule" "redirect_root_to_www" {
  for_each = local.use_cloudflare && var.redirect_root_to_www ? { "enabled" : true } : {}

  zone_id  = data.cloudflare_zone.this[0].zone_id
  target   = "${var.domain_name}/*"
  priority = 1
  status   = "active"

  actions = {
    forwarding_url = {
      url         = "https://www.${var.domain_name}/$1" # Redirect to www preserving path
      status_code = 301                                 # Permanent redirect
    }
  }
}

# Route53 records
resource "aws_route53_record" "this" {
  for_each = local.use_route53 ? toset(local.distinct_domain_names_without_base) : []

  zone_id = data.aws_route53_zone.this[0].zone_id
  name    = each.value == "" ? "" : each.value
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}
