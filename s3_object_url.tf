# Get the file's URL. Before applying and destorying, remark the file
data "aws_s3_bucket_objects" "sa-demo" {
  bucket = aws_s3_bucket.sa-demo.id
}

data "aws_s3_bucket_object" "sa-demo" {
  count  = length(data.aws_s3_bucket_objects.sa-demo.keys)
  key    = element(data.aws_s3_bucket_objects.sa-demo.keys, count.index)
  bucket = data.aws_s3_bucket_objects.sa-demo.bucket

    depends_on = [
    aws_s3_bucket.sa-demo,
    data.aws_s3_bucket_objects.sa-demo
  ]
}

output "object_url" {
  value = [ for value in data.aws_s3_bucket_objects.sa-demo.keys: "https://${aws_s3_bucket.sa-demo.bucket_regional_domain_name}/${value}"]
}