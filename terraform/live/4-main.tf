module "acm" {
    source = "../modules/acm"

    dns_provider = "cloudflare"
    domain_name = var.domain_name[terraform.workspace]
    subject_alternative_names = var.subject_alternative_names[terraform.workspace]
    zone_name = var.zone_name[terraform.workspace]
    cloudflare_api_key = var.cloudflare_api_key[terraform.workspace]
    tags = local.tags
}

module "s3-website" {
    source = "../modules/s3-website"

    project_name = var.project_name
    env = terraform.workspace
    region = var.region[terraform.workspace]
    acm_certificate = module.acm.acm_certificate_arn
    aliases = var.aliases[terraform.workspace]
    enable_failover_s3 = var.enable_failover_s3[terraform.workspace]
}