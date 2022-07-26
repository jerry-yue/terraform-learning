variable "aws_region" {
  type        = string
  default     = "ap-southeast-1"
  description = "Stage 1: AWS Region"
}

variable "aws_ec2_type" {
  type        = string
  default     = "t2.micro"
  description = "Stage 1: AWS EC2 Type"
}

# variable "aws_ec2_ami" {
#   type = map(string)
#   default = {
#     amzn2   = "ami-0c802847a7dd848c0",
#     ubt22   = "ami-02ee763250491e04a",
#     win2019 = "ami-050d504434d8b9ec5",
#     rhel8   = "ami-051f0947e420652a9"
#   }
#   description = "Stage 1: AWS EC2 AMI"
# }

# names: return the name list of available zone
#   + sa-demo-get-az-list = [
#      + "ap-southeast-1a",
#      + "ap-southeast-1b",
#      + "ap-southeast-1c",
#    ]
# data.aws_availability_zones.available.names[0]
data "aws_availability_zones" "available" {}

variable "availability_zone_0" {
  type        = string
  default     = ""
  description = "Singapore 1a Zone"
}

data "external" "current_ip" {
  program = ["bash", "-c", "curl -s 'https://api.ipify.org?format=json'"]
}

variable "aws_ebs_device_name" {
  type = string
  default = "/dev/sdd"
  description = "AWS EBS Storage Device Name"
}

variable "test_tmp_path" {
  type = string
  default = "/tmp"
}

