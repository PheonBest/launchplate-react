locals {
  use_cloudflare = var.dns_provider == "cloudflare"
  use_route53    = !local.use_cloudflare

  # Get distinct list of domains and SANs
  distinct_domain_names = distinct(
    [for s in concat([var.domain_name], var.subject_alternative_names) : replace(s, "*.", "")]
  )

  domain_name_without_base = replace(var.domain_name, ".${var.base_domain}", "")
}

locals {
  # Get distinct list of domains and SANs without base domain
  # (remove the last part)
  # if using Cloudflare and redirecting root to www, only create the www record
  distinct_domain_names_without_base = (
    local.use_cloudflare && var.redirect_root_to_www
    ? ["www.${local.domain_name_without_base}"]
    : distinct([
      for s in local.distinct_domain_names :
      replace(s, ".${var.base_domain}", "")
    ])
  )
}
