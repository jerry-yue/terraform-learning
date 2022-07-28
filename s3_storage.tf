# Storage: S3
resource "aws_s3_bucket" "sa-demo" {
  bucket        = "sa-demo-resouce-bucket"
  force_destroy = true
  tags = merge(local.default_tags, {
    Res  = "storage-res",
    Name = "${local.name}-${local.suffix}-${local.az}"
  })
}
resource "aws_s3_bucket_acl" "sa-demo" {
  bucket = aws_s3_bucket.sa-demo.id
  acl    = "private"
}
# resource "aws_s3_bucket_logging" "sa-demo" {
#   bucket = aws_s3_bucket.sa-demo.id
#   target_bucket = aws_s3_bucket.log_bucket.id
#   target_prefix = "log/"
# }

#upload files to S3 bucket
resource "aws_s3_bucket_object" "sa-demo" {
  bucket   = aws_s3_bucket.sa-demo.id
  for_each = fileset("screenshots/", "*")
  key      = "screenshots/${each.value}" # file name and path in S3
  source   = "screenshots/${each.value}" # file in local host
  etag     = filemd5("screenshots/${each.value}")

  depends_on = [
    aws_s3_bucket.sa-demo
  ]
}

# Access Log Bucket
# resource "aws_s3_bucket" "log_bucket" {
#   # acl listed here has been deprecated
#   bucket        = "sa-demo-log-bucket"
#   # policy = data.aws_iam_policy_document.sa-demo
#   force_destroy = true
#   tags = merge(local.default_tags, {
#     Res  = "storage-log",
#     Name = "${local.name}-${local.suffix}-${local.az}"
#   })
# }
# resource "aws_s3_bucket_acl" "sa-log_bucket" {
#   bucket = aws_s3_bucket.log_bucket.id
#   acl    = "log-delivery-write" # canned-acl
# }

# Policy to allow * to access the uploaded files
resource "aws_s3_bucket_policy" "sa-demo" {
  bucket = aws_s3_bucket.sa-demo.id
  policy = data.aws_iam_policy_document.sa-demo.json
}

data "aws_iam_policy_document" "sa-demo" {
  statement {
    # policy_id = "Policy1658998342090" # wrong var
    # sid       = "Stmt1658996997160"
    effect    = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.sa-demo.arn,
      "${aws_s3_bucket.sa-demo.arn}/*",
    ]
  }
}