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
