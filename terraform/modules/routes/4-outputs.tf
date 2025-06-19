# Output the DNS records created
output "cloudflare_record_ids" {
  description = "The Cloudflare Record IDs"
  value       = local.use_cloudflare ? [for record in cloudflare_dns_record.this : record.id] : []
}

output "cloudflare_record_id_proxied_route" {
  description = "The Cloudflare Record ID for proxied route"
  value       = local.use_cloudflare && var.redirect_root_to_www ? cloudflare_dns_record.proxied_route["enabled"].id : null
}

output "route53_record_names" {
  description = "The Route53 Record Names"
  value       = local.use_route53 ? [for record in aws_route53_record.this : record.name] : []
}

output "domain_records" {
  description = "List of domain names for which records were created"
  value       = local.distinct_domain_names_without_base
}
