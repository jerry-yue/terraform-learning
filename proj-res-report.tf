# data "aws_instance" "created-res-ec2" {
#   filter {
#     name   = "image-id"
#     values = [data.aws_ami.amzn2_x86-64.image_id]
#   }
#   filter {
#     name   = "tag:User"
#     values = ["jyue"]
#   }
#   filter {
#     name   = "tag:Res"
#     values = ["ec2"]
#   }
#   filter {
#     name   = "tag:Name"
#     values = ["${local.name}-${local.suffix}"]
#   }
# }