# Creates Access Control List to secure  CloudFront distribution

resource "aws_wafv2_web_acl" "this" {
  for_each = var.enable_waf ? { "enabled" = true } : {}

  name        = "${var.env}-${var.project_name}-cloudfront-waf"
  description = "WAF for CloudFront serving S3 static website"
  scope       = "CLOUDFRONT" # Must be CLOUDFRONT for CloudFront distributions[6][8]
  provider    = aws.useast1

  default_action {
    allow {}
  }

  custom_response_body {
    key          = "blocked_request_custom_response"
    content      = "{\n    \"error\":\"Too Many Requests.\"\n}"
    content_type = "APPLICATION_JSON"
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "cloudfront-waf"
    sampled_requests_enabled   = true
  }

  tags = {
    Name        = "${var.env}-${var.project_name}"
    Environment = var.env
    Project     = var.project_name
  }

  rule {
    name     = "RateLimit"
    priority = 1

    action {
      block {
        custom_response {
          custom_response_body_key = "blocked_request_custom_response"
          response_code            = 429
        }
      }
    }

    statement {

      rate_based_statement {
        aggregate_key_type = "IP"
        limit              = 200
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimit"
      sampled_requests_enabled   = true
    }
  }

  # Block malicious IP addresses
  dynamic "rule" {
    for_each = var.enable_ruleset_ip_reputation ? [1] : []
    content {
      name     = "AWS-AWSManagedRulesAmazonIpReputationList"
      priority = 2

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesAmazonIpReputationList"
          vendor_name = "AWS"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesAmazonIpReputationList"
        sampled_requests_enabled   = true
      }
    }
  }

  # Protect against common web exploits like SQL injection and XSS
  dynamic "rule" {
    for_each = var.enable_ruleset_common ? [1] : []
    content {
      name     = "AWS-AWSManagedRulesCommonRuleSet"
      priority = 3

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesCommonRuleSet"
          vendor_name = "AWS"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesCommonRuleSet"
        sampled_requests_enabled   = true
      }
    }
  }

  # Protect against knonw bad inputs (e.g. malicious SQL, shell commands)
  dynamic "rule" {
    for_each = var.enable_ruleset_known_bad_inputs ? [1] : []
    content {
      name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      priority = 4

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesKnownBadInputsRuleSet"
          vendor_name = "AWS"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesKnownBadInputsRuleSet"
        sampled_requests_enabled   = true
      }
    }
  }
}


resource "aws_cloudwatch_log_group" "WafWebAclLoggroup" {
  for_each = var.enable_waf ? { "enabled" = true } : {}

  name              = "${local.prefix}-aws-waf-logs-wafv2-web-acl"
  retention_in_days = 30

  tags = var.tags
}

resource "aws_wafv2_web_acl_logging_configuration" "WafWebAclLogging" {
  for_each = var.enable_waf ? { "enabled" = true } : {}

  log_destination_configs = [aws_cloudwatch_log_group.WafWebAclLoggroup["enabled"].arn]
  resource_arn            = aws_wafv2_web_acl.this["enabled"].arn
  depends_on = [
    aws_wafv2_web_acl.this,
    aws_cloudwatch_log_group.WafWebAclLoggroup
  ]
}
