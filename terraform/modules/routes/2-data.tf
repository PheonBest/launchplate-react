data "cloudflare_zone" "this" {
  count = local.use_cloudflare ? 1 : 0
  filter = {
    name = var.zone_name
  }
}

data "aws_route53_zone" "this" {
  count = local.use_route53 ? 1 : 0
  name  = var.zone_name
}
