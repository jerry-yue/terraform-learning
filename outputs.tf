# output "aws_ami_id_amzn2_x86_64bit" {
#   description = "Amazon Linux2 x86-64 OS AMI ID"
#   value       = data.aws_ami.amzn2_x86-64.image_id
# }

# output "aws_ami_id_ubuntu22_x86_64bit" {
#   description = "Ubuntu 22.04 x86-64 OS AMI ID"
#   value       = data.aws_ami.ubt22_x86-64.image_id
# }

# output "aws_ami_id_win2019_x86_64bit" {
#   description = "Windows Server 2019 x86-64 OS AMI ID"
#   value       = data.aws_ami.win2019_x86-64.image_id
# }

# output "aws_ami_id_rhel8_x86_64bit" {
#   description = "Red Hat 8.x x86-64 OS AMI ID"
#   value       = data.aws_ami.rhel8_x86-64.image_id
# }

# output "sa-demo-created-resource-ec2" {
#   description = "This project created resource list: ec2"
#   value       = data.aws_instance.created-res-ec2.host_id
# }

# output "sa-demo-get-az-name-list" {
#   value = data.aws_availability_zones.available.names
# }

# output "sa-demo-get-az-group-name" {
#   value = data.aws_availability_zones.available.group_names
# }

output "this_host_external_ip" {
  value = local.ext_ip_cidr_16
}

output "sa-demo-instance-public-dns" {
  value = aws_instance.sa-demo.public_dns
}

output "sa-demo-instance-public-ip" {
  value = aws_instance.sa-demo.public_ip
}