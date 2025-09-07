resource "random_id" "this" {
  byte_length = 8
}

resource "aws_s3_bucket" "this" {
  for_each      = var.buckets
  bucket        = "${each.value.name}-${random_id.this.hex}"
  force_destroy = false
  tags = {
    Name        = each.value.name
    Environment = var.environment
  }
}


resource "aws_s3_bucket_public_access_block" "this" {
  for_each                = aws_s3_bucket.this
  bucket                  = each.value.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


output "buckets" {
  description = "The names of the created S3 buckets"
  value       = { for k, v in aws_s3_bucket.this : k => v.bucket }
}