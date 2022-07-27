variable "key_pair_file" {
  type        = string
  default     = "sa_demo_keypair.pem.prikey"
  description = "Generate Key-pair file by Terraform"
}

resource "tls_private_key" "sa-demo" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "sa-demo" {
  key_name   = var.key_pair_file
  public_key = tls_private_key.sa-demo.public_key_openssh

  tags = merge(local.default_tags, {
    Res  = "key-pair",
    Name = "${local.name}-${local.suffix}"
  })

}

# Save the private key file to disk for ssh connection locally
# The key-value can be found in tfstate file
# ssh pubkey also can be created via ssh-keygen -y -f /path_to_key_pair/my-key-pair.pem
resource "local_sensitive_file" "sa-demo" {
  filename        = pathexpand(var.key_pair_file)
  file_permission = "0400"
  #   directory_permission = "700"
  # sensitive_content = tls_private_key.sa-demo.private_key_pem # local_file deprecated
  content = tls_private_key.sa-demo.private_key_pem

  # provisioner "local-exec" { # Generate "terraform-key-pair.pem" in current directory
  #   command = <<-EOT
  #     rm -f ${self.filename}
  #     echo '${tls_private_key.sa-demo.private_key_pem}' > ${self.filename}
  #   EOT
  # }
}

# output "sa-demo-key-pair-ssh" {
#   description = "Generated Key-pair file by Terraform"
#   value       = tls_private_key.sa-demo.public_key_openssh
# }

