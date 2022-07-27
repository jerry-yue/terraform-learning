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
  # user_data = file("user_data/user_data.sh")
  # provisioner "file" {
  #   # 需要 connection block。具体参考官方文档
  #   source      = "./fdisk_param"              # On local host disk
  #   destination = var.aws_ebs_fdisk_param_file # on EC2 Instance
  # }
  # connection {
  #   type        = "ssh"
  #   user        = "ec2-user"
  #   port        = "22"
  #   host        = element(aws_eip.eip.*.public_ip, count.index)
  #   private_key = file(var.ssh_private_key)
  # }

  # depends_on = [
  #   var.key_pair_file,
  #   aws_ebs_volume.sa-demo,
  #   var.aws_ebs_fdisk_param_file
  # ]

  tags = merge(local.default_tags, {
    Res  = "ec2",
    Name = "${local.name}-${local.suffix}"
  })
}
