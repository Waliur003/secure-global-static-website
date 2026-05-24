//output s3 bucket name
output "s3_bucket_name" {
  value = aws_s3_bucket.my_bucket.bucket
  description = "The name of the S3 bucket created for static website hosting"
}

//output s3 bucket arn
output "s3_bucket_arn" {
  value = aws_s3_bucket.my_bucket.arn
  description = "The ARN of the S3 bucket created for static website hosting"
}

//Output CloudFront URL
output "cloudfront_url" {
  value = aws_cloudfront_distribution.my_distribution.domain_name
  description = "The URL of the CloudFront distribution for the static website"
}