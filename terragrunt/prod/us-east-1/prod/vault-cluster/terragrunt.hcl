locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  environment = local.environment_vars.locals.environment
  component   = local.environment_vars.locals.component
  creator     = local.environment_vars.locals.creator
}

terraform {
  source = "${get_terragrunt_dir()}/../../../../../terraform/modules/vault"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  availability_zones       = "us-east-1a"
  aws_kms_key              = "${get_env("AWS_KMS_KEY")}"
  prefix                   = "vault-cluster-${local.environment}"
  vault_server_private_ips = ["10.0.101.22", "10.0.101.23", "10.0.101.24"]
  cidr                     = "10.0.1.0/16"
  private_subnets          = ["10.0.1.0/24"]
  public_subnets           = ["10.0.101.0/24"]
  common_tags = {
    Environment = local.environment
    Component   = local.component
    Creator     = local.creator
  }
}
