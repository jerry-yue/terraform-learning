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

# resource "aws_network_interface" "sa-demo" {
#   subnet_id = aws_subnet.sa-demo.id
#   # private_ips = ["172.16.1.50"]
#   security_groups = [aws_security_group.sa-demo.id]
#   tags = merge(local.default_tags, {
#     Res  = "adapter",
#     Name = "${local.name}-${local.suffix}-${local.az}"
#   })

#   # attachment {
#   #   instance = aws_instance.sa-demo.id
#   #   device_index = 1
#   # }
# }
