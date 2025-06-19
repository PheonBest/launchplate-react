<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.62 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.0 |
## Usage
Basic usage of this module is as follows:
```hcl
module "example" {
  	 source  = "<module-path>"

	 # Required variables
    	 acm_certificate  =
    	 aliases  =
    	 enable_failover_s3  =
    	 env  =
    	 project_name  =
    	 region  =

	 # Optional variables
    	 enable_ruleset_common  = false
    	 enable_ruleset_ip_reputation  = false
    	 enable_ruleset_known_bad_inputs  = false
    	 html_source_dir  = "static/html/"
    	 index_document  = "index.html"
    	 price_class  = "PriceClass_100"
    	 tags  = {}
  }
```
## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity) | resource |
| [aws_cloudwatch_log_group.WafWebAclLoggroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_kms_key.shared](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.failover](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.log_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_logging.failover](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_logging.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_policy.failover_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.log_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.primary_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.failover](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.log_public_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.primary_public_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.failover](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.primary_encryption_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_website_configuration.failover](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_s3_bucket_website_configuration.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_wafv2_web_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_logging_configuration.WafWebAclLogging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.s3_failover_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificate"></a> [acm\_certificate](#input\_acm\_certificate) | The ARN of the ACM certificate | `string` | n/a | yes |
| <a name="input_aliases"></a> [aliases](#input\_aliases) | The aliases for the CloudFront distribution | `list(string)` | n/a | yes |
| <a name="input_enable_failover_s3"></a> [enable\_failover\_s3](#input\_enable\_failover\_s3) | If true, deploy a failover S3 bucket | `bool` | n/a | yes |
| <a name="input_enable_ruleset_common"></a> [enable\_ruleset\_common](#input\_enable\_ruleset\_common) | Enable AWS Managed Rules Common Rule Set | `bool` | `false` | no |
| <a name="input_enable_ruleset_ip_reputation"></a> [enable\_ruleset\_ip\_reputation](#input\_enable\_ruleset\_ip\_reputation) | Enable AWS Managed Rules IP Reputation List | `bool` | `false` | no |
| <a name="input_enable_ruleset_known_bad_inputs"></a> [enable\_ruleset\_known\_bad\_inputs](#input\_enable\_ruleset\_known\_bad\_inputs) | Enable AWS Managed Rules Known Bad Inputs Rule Set | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment name | `string` | n/a | yes |
| <a name="input_html_source_dir"></a> [html\_source\_dir](#input\_html\_source\_dir) | Directory path for HTML source files | `string` | `"static/html/"` | no |
| <a name="input_index_document"></a> [index\_document](#input\_index\_document) | The index document of the website | `string` | `"index.html"` | no |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | The price class for the CloudFront distribution | `string` | `"PriceClass_100"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags | `map(string)` | `{}` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_distribution_domain"></a> [cloudfront\_distribution\_domain](#output\_cloudfront\_distribution\_domain) | n/a |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | The name of the S3 bucket hosting the website |
| <a name="output_s3_bucket_url"></a> [s3\_bucket\_url](#output\_s3\_bucket\_url) | The website URL of the S3 bucket |
| <a name="output_s3_failover_bucket_url"></a> [s3\_failover\_bucket\_url](#output\_s3\_failover\_bucket\_url) | The website URL of the S3 failover bucket hosting the website |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->
