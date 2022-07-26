data "aws_ami" "amzn2_x86-64" {
  #   executable_users = ["self"]
  most_recent = true
  #   name_regex       = "^myami-\\d{3}"
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}

# data "aws_ami" "ubt22_x86-64" {
#   #   executable_users = ["self"]
#   most_recent = true
#   #   name_regex       = "^myami-\\d{3}"
#   owners = ["099720109477"]
#   filter {
#     name   = "name"
#     values = ["ubuntu-*-22.04-*"]
#   }
#   filter {
#     name   = "root-device-type"
#     values = ["ebs"]
#   }
#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
#   filter {
#     name   = "architecture"
#     values = ["x86_64"]
#   }
#   filter {
#     name   = "state"
#     values = ["available"]
#   }
# }


# data "aws_ami" "win2019_x86-64" {
#   #   executable_users = ["self"]
#   most_recent = true
#   #   name_regex       = "^myami-\\d{3}"
#   owners = ["801119661308"]
#   filter {
#     name   = "platform"
#     values = ["windows"]
#   }
#   filter {
#     name   = "name"
#     values = ["*2019*"]
#   }
#   filter {
#     name   = "root-device-type"
#     values = ["ebs"]
#   }
#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
#   filter {
#     name   = "architecture"
#     values = ["x86_64"]
#   }
#   filter {
#     name   = "state"
#     values = ["available"]
#   }
# }

# data "aws_ami" "rhel8_x86-64" {
#   #   executable_users = ["self"]
#   most_recent = true
#   #   name_regex       = "^myami-\\d{3}"
#   owners = ["309956199498"]
#   filter {
#     name   = "name"
#     values = ["RHEL-8*"]
#   }
#   filter {
#     name   = "root-device-type"
#     values = ["ebs"]
#   }
#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
#   filter {
#     name   = "architecture"
#     values = ["x86_64"]
#   }
#   filter {
#     name   = "state"
#     values = ["available"]
#   }
# }