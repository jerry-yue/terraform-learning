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