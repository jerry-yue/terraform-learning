# Load balancer: NLB
resource "aws_lb" "sa-demo" {
  name               = "sa-demo"
  internal           = false
  load_balancer_type = "network" # default type is application
  # security_groups    = [aws_security_group.sa-demo.id]
  subnets = [aws_subnet.sa-demo.id] # alb require at least 2 subnets
  enable_deletion_protection = false # if true, tfd will not delete it
  # Require S3 Resource of log_bucket
  # access_logs {
  #   bucket  = aws_s3_bucket.log_bucket.bucket
  #   prefix  = "sa-demo-nlb-log"
  #   enabled = true
  # }
  tags = merge(local.default_tags, {
    Res  = "alb",
    Name = "${local.name}-${local.suffix}-${local.az}"
  })
}
# data "aws_elb_service_account" "sa-demo" {}

# data "aws_iam_policy_document" "sa-demo" {
#     policy_id = "sa-demo-s3_elb_log_write"

#     statement {
#         actions = ["s3:PutObject"]
#         resources = ["arn:aws:s3:::${aws_s3_bucket.log_bucket.id}/logs/*"]

#         principals {
#             identifiers = ["${data.aws_elb_service_account.sa-demo.arn}"]
#             type = "AWS"
#         }
#     }
# }

resource "aws_lb_target_group" "sa-demo" {
  name        = "sa-demo"
  port        = 80
  protocol    = "TCP"      # Application HTTP,HTTPS; Network TCP, UDP
  target_type = "instance" # default value is instance, can be ip, alb, lambda etc
  vpc_id      = aws_vpc.sa-demo.id
}

resource "aws_lb_target_group_attachment" "sa-demo" {
  target_group_arn = aws_lb_target_group.sa-demo.arn
  target_id        = aws_instance.sa-demo.id
  port             = 80
}

resource "aws_lb_listener" "sa-demo" {
  load_balancer_arn = aws_lb.sa-demo.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sa-demo.arn
  }
}