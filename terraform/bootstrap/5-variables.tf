variable "region" {
  description = "AWS Region"
  type        = string
  default = "eu-west-3"
}

variable "state_bucket_name" {
  description = "State bucket name"
  type        = string
  default = "launchplate-react-tfstate"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name"
  type        = string
  default = "launchplate-react-tfstate-locks"
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default = {
    Environment = "Dev"
    Project     = "react-launchplate"
    ManagedBy   = "Terraform"
  }
}