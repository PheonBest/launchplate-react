terraform {
  backend "s3" {
    bucket               = "launchplate-react-tfstate"
    dynamodb_table       = "launchplate-react-tfstate-locks"
    encrypt              = true
    key                  = "terraform.tfstate"
    region               = "eu-west-3"
    workspace_key_prefix = "workspaces"
  }
}
