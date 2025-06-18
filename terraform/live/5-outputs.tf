output "current_workspace_name" {
  value       = terraform.workspace
  description = "The name of the currently active Terraform workspace."
}

output "acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = "${module.acm.acm_certificate_arn}"
}

output "acm_certificate_domain_validation_options" {
  description = "A list of attributes to feed into other resources to complete certificate validation. Can have more than one element, e.g. if SANs are defined."
  value       = "${module.acm.acm_certificate_domain_validation_options}"
}

output "validation_dns_record_fqdns" {
  description = "List of FQDNs built using the zone domain and name."
  value       = "${module.acm.validation_dns_record_fqdns}"
}

output "distinct_domain_names" {
  description = "List of distinct domains names used for the validation."
  value       = "${module.acm.distinct_domain_names}"
}

output "validation_domains" {
  description = "List of distinct domain validation options. This is useful if subject alternative names contain wildcards."
  value       = "${module.acm.validation_domains}"
}
