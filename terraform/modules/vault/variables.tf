# AWS region and AZs in which to deploy
variable "aws_region" {
  description = "aws region"
}

variable "availability_zones" {
  description = "zone"
}

# All resources will be tagged with this
variable "environment_name" {
  default = "vault-server"
}

variable "vault_server_names" {
  description = "Names of the Vault nodes that will join the cluster"
  type        = list(string)
  default     = ["vault-1", "vault-2", "vault-3"]
}

variable "vault_server_private_ips" {
  description = "The private ips of the Vault nodes that will join the cluster"
  # @see https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html
  type = list(string)
}


# URL for Vault OSS binary
variable "vault_zip_file" {
  default = "https://releases.hashicorp.com/vault/1.9.0/vault_1.9.0_linux_amd64.zip"
}

# Instance size
variable "instance_type" {
  default = "t2.micro"
}

# SSH key name to access EC2 instances (should already exist) in the AWS Region
variable "key_name" {
  default = "myrsa"
}

# aws kms key
variable "aws_kms_key" {
  description = "kms key"
}
