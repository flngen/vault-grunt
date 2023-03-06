# Set account-wide variables
locals {
  account_name   = "someuser"
  aws_account_id = "${get_env("AWS_ACCOUNT_ID")}"
  aws_profile    = "default"
}
