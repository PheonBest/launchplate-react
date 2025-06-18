<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->

## Requirements

| Name                                                                     | Version |
| ------------------------------------------------------------------------ | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | ~> 1.0  |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | ~> 4.62 |
| <a name="requirement_null"></a> [null](#requirement_null)                | ~> 3.0  |

## Usage

Basic usage of this module is as follows:

```hcl
module "example" {
	 source  = "<module-path>"

	 # Required variables
	 aws_region  =
	 env  =
	 project  =

	 # Optional variables
	 html_source_dir  = "static/html/"
	 index_document  = "index.html"
}
```

## Resources

| Name                                                                                                                                                                                      | Type        |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution)                                                   | resource    |
| [aws_cloudfront_origin_access_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity)                               | resource    |
| [aws_kms_key.shared](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key)                                                                                 | resource    |
| [aws_s3_bucket.failover](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)                                                                           | resource    |
| [aws_s3_bucket.log_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)                                                                         | resource    |
| [aws_s3_bucket.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)                                                                            | resource    |
| [aws_s3_bucket_acl.log_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl)                                                                 | resource    |
| [aws_s3_bucket_logging.failover](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging)                                                           | resource    |
| [aws_s3_bucket_logging.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging)                                                               | resource    |
| [aws_s3_bucket_policy.static_website_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy)                                         | resource    |
| [aws_s3_bucket_public_access_block.failover_public_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block)                     | resource    |
| [aws_s3_bucket_public_access_block.log_public_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block)                          | resource    |
| [aws_s3_bucket_public_access_block.public_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block)                              | resource    |
| [aws_s3_bucket_server_side_encryption_configuration.failover](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource    |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration)     | resource    |
| [aws_s3_bucket_website_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration)                                   | resource    |
| [aws_s3_object.static_site_upload_object](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object)                                                          | resource    |
| [aws_s3_object.static_site_upload_object_failover](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object)                                                 | resource    |
| [aws_wafv2_web_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl)                                                                       | resource    |
| [null_resource.invalidate_html](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource)                                                                    | resource    |
| [aws_iam_policy_document.s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)                                                   | data source |

## Inputs

| Name                                                                           | Description                          | Type     | Default          | Required |
| ------------------------------------------------------------------------------ | ------------------------------------ | -------- | ---------------- | :------: |
| <a name="input_aws_region"></a> [aws_region](#input_aws_region)                | The AWS region                       | `string` | n/a              |   yes    |
| <a name="input_env"></a> [env](#input_env)                                     | Environment name                     | `string` | n/a              |   yes    |
| <a name="input_html_source_dir"></a> [html_source_dir](#input_html_source_dir) | Directory path for HTML source files | `string` | `"static/html/"` |    no    |
| <a name="input_index_document"></a> [index_document](#input_index_document)    | The index document of the website    | `string` | `"index.html"`   |    no    |
| <a name="input_project"></a> [project](#input_project)                         | Project name                         | `string` | n/a              |   yes    |

## Outputs

| Name                                                                                                                          | Description                                   |
| ----------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------- |
| <a name="output_cloudfront_distribution_domain"></a> [cloudfront_distribution_domain](#output_cloudfront_distribution_domain) | n/a                                           |
| <a name="output_s3_bucket_name"></a> [s3_bucket_name](#output_s3_bucket_name)                                                 | The name of the S3 bucket hosting the website |
| <a name="output_s3_bucket_url"></a> [s3_bucket_url](#output_s3_bucket_url)                                                    | The website URL of the S3 bucket              |

<!-- END_AUTOMATED_TF_DOCS_BLOCK -->
