provider "aws" {
  region                  = var.aws_region
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"

}

# provider "aws" {
#   region = local.region
# }

resource "random_string" "suffix" {
  length  = 8
  special = false
}


locals {
  name   = "aws-sa-demo"
  suffix = random_string.suffix.result
  # region = "ap-southeast-1"
  az             = data.aws_availability_zones.available.names[0]
  split_ext_ip   = split(".", data.external.current_ip.result.ip)
  ext_ip_cidr_16 = "${join(".", ["${local.split_ext_ip[0]}", "${local.split_ext_ip[1]}", "0", "0"])}/16"

  # 初始化EC2 VM，第一次启动时执行，之后不执行
  user_data = <<-EOT
  #!/bin/bash
  sudo yum update -y
  sudo yum install amazon-linux-extras -y
  # For nginx's requirement
  sudo yum install openssl11-libs -y

  # Config Nginx web server
  sudo amazon-linux-extras install nginx1 -y
  sudo echo "<h1>Hello AWS World</h1>" >  /usr/share/nginx/html/index.html 
  sudo systemctl enable nginx
  sudo systemctl start nginx

  # Mount EBS disk
  sudo touch "${var.test_tmp_path}/test.sh"
  sudo lsblk > "${var.test_tmp_path}/test.sh"
  # sudo mkfs -t xfs /dev/xvdd
  EOT

  default_tags = {
    User = "jyue"
    Proj = "aws-sa-demo"
  }
}

resource "aws_instance" "sa-demo" {
  ami           = data.aws_ami.amzn2_x86-64.image_id
  instance_type = var.aws_ec2_type
  # adapter_zone must the same as the instance_zone
  # if in different zones, there will be an error
  availability_zone      = local.az
  vpc_security_group_ids = [aws_security_group.sa-demo.id]
  # 手动绑定 ENI 没有 public IP，index不可以是1，只能从0开始
  # 如果要为EC2添加额外的 ENI 只能attach，不能直接添加
  # network_interface {
  #   network_interface_id = aws_network_interface.sa-demo.id
  #   device_index         = 1
  # }
  subnet_id                   = aws_subnet.sa-demo.id
  associate_public_ip_address = true
  # associate_public_ip_address与network_interface冲突
  key_name = var.key_pair_file

  user_data = local.user_data

  depends_on = [
    var.key_pair_file
  ]

  tags = merge(local.default_tags, {
    Res  = "ec2",
    Name = "${local.name}-${local.suffix}"
  })
}

resource "aws_internet_gateway" "sa-demo" {
  vpc_id = aws_vpc.sa-demo.id

  tags = merge(local.default_tags, {
    Res  = "Gateway",
    Name = "${local.name}-${local.suffix}"
  })
}

resource "aws_route_table" "sa-demo" {
  vpc_id = aws_vpc.sa-demo.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sa-demo.id
  }

  tags = merge(local.default_tags, {
    Res  = "Route_Table",
    Name = "${local.name}-${local.suffix}"
  })
}

resource "aws_route_table_association" "sa-demo" {
  subnet_id      = aws_subnet.sa-demo.id
  route_table_id = aws_route_table.sa-demo.id
}

resource "aws_vpc" "sa-demo" {
  cidr_block           = "172.16.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = merge(local.default_tags, {
    Res  = "vpc",
    Name = "${local.name}-${local.suffix}-${local.az}"
  })
}

resource "aws_subnet" "sa-demo" {
  vpc_id            = aws_vpc.sa-demo.id
  cidr_block        = "172.16.1.0/24"
  availability_zone = local.az
  tags = merge(local.default_tags, {
    Res  = "subnet",
    Name = "${local.name}-${local.suffix}-${local.az}"
  })
}

resource "aws_network_interface" "sa-demo" {
  subnet_id = aws_subnet.sa-demo.id
  # private_ips = ["172.16.1.50"]
  security_groups = [aws_security_group.sa-demo.id]
  tags = merge(local.default_tags, {
    Res  = "adapter",
    Name = "${local.name}-${local.suffix}-${local.az}"
  })

  # attachment {
  #   instance = aws_instance.sa-demo.id
  #   device_index = 1
  # }
}

# resource "aws_key_pair" "sa-demo" {

# }

resource "aws_security_group" "sa-demo" {
  name        = "sa-demo"
  description = "Security Group For sa-demo environment."
  vpc_id      = aws_vpc.sa-demo.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.ext_ip_cidr_16]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.ext_ip_cidr_16]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.ext_ip_cidr_16]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.default_tags, {
    Res  = "sg",
    Name = "${local.name}-${local.suffix}-${local.az}"
  })
}

# 1. 不能重复挂载同一个SG，
# 2. 这种方法只适合挂载多个SG。如果不指定，EC2会挂载一个默认的SG
# 3. 如果不需要EC2挂载默认的SG，需要显示的指定一个SG vpc_security_group_ids
# resource "aws_network_interface_sg_attachment" "sa-demo" {
#   security_group_id    = aws_security_group.sa-demo.id
#   network_interface_id = aws_instance.sa-demo.primary_network_interface_id
# }

# key-Pair
# key pair generated in key-pair.tf
# resource "aws_key_pair" "sa-demo" {
#   key_name   = "sa-demo-pubkey"
#   public_key = tls_private_key.sa-demo.public_key_openssh
# }

resource "aws_ebs_volume" "sa-demo" {
  availability_zone = local.az
  size              = 1

  tags = merge(local.default_tags, {
    Res  = "storage_ebs",
    Name = "${local.name}-${local.suffix}-${local.az}"
  })
}

resource "aws_volume_attachment" "sa-demo" {
  device_name = var.aws_ebs_device_name
  volume_id   = aws_ebs_volume.sa-demo.id
  instance_id = aws_instance.sa-demo.id
}



# S3