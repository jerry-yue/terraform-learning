provider "aws" {
  region                  = var.aws_region
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

# What is vault