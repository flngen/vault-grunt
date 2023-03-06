terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}



//--------------------------------------------------------------------
// Vault Server Instance

resource "aws_instance" "vault-server" {
  count                       = length(var.vault_server_names)
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = module.vault-server-vpc.public_subnets[0]
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.vault-server.id]
  associate_public_ip_address = true
  private_ip                  = var.vault_server_private_ips[count.index]
  iam_instance_profile        = aws_iam_instance_profile.vault-server.id

  # user_data = data.template_file.vault-server[count.index].rendered
  user_data = templatefile("${path.module}/templates/userdata-vault-server.tpl", {
    tpl_vault_node_name          = var.vault_server_names[count.index],
    tpl_vault_storage_path       = "/vault/${var.vault_server_names[count.index]}",
    tpl_vault_zip_file           = var.vault_zip_file,
    tpl_vault_service_name       = "vault-${var.environment_name}",
    tpl_aws_kms_key              = "${var.aws_kms_key}",
    tpl_aws_region               = "${var.aws_region}",
    tpl_vault_node_address_names = zipmap(var.vault_server_private_ips, var.vault_server_names)
  })

  tags = {
    Name         = "${var.environment_name}-${var.vault_server_names[count.index]}"
    cluster_name = "${var.environment_name}"
  }

  lifecycle {
    ignore_changes = [ami, tags]
  }
}

