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
    # sudo yum update -y
    # sudo yum install amazon-linux-extras -y
    # For nginx's requirement
    echo ">> installing openssl11 <<"
    sudo yum install openssl11-libs -y
    echo ">> installing nginx and create mount point below <<"
    sudo amazon-linux-extras install nginx1 -y
    echo ">> Format EBS volume <<"
    sudo echo -e "n\np\n1\n\n\nwq" > ${var.aws_ebs_fdisk_param_file}
    sudo fdisk ${var.aws_ebs_device_name} < ${var.aws_ebs_fdisk_param_file}
    echo ">> Formated EBS volume <<"
    sleep 1
    sudo mkfs -t xfs ${var.aws_ebs_device_name}1 >> /tmp/test.log
    echo ">> Auto mounting setup after reboot <<"
    sudo chmod 0777 /etc/fstab
    sudo echo '${var.aws_ebs_device_name}1     /usr/share/nginx/html    xfs    defaults        1 2'  >> /etc/fstab
    sudo chmod 0644 /etc/fstab
    echo ">> Mount EBS volume <<"
    sudo mount ${var.aws_ebs_device_name}1 /usr/share/nginx/html
    echo ">> Config Nginx web server <<"
    sudo echo "<h1>Hello AWS World</h1>" >  /usr/share/nginx/html/index.html 
    sudo echo "<br/><br/><br/>
                <h2>Pic1</h2>
                <img src='https://sa-demo-resouce-bucket.s3.ap-southeast-1.amazonaws.com/screenshots/ebs_volume_auto_mount.png' />
                <br/><br/><br/>
                <h2>Pic2</h2>
                <img src='https://sa-demo-resouce-bucket.s3.ap-southeast-1.amazonaws.com/screenshots/mounted_ebs_volume.png'/>" >>  /usr/share/nginx/html/index.html 
    sudo systemctl enable nginx
    sudo systemctl start nginx
  EOT

  default_tags = {
    User = "jyue"
    Proj = "aws-sa-demo"
  }
}