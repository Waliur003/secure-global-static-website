//create s3 bucket Bucket name: Enter a globally unique name (global-static-portfolio-origin)
resource "aws_s3_bucket" "my_bucket" {
  bucket = "global-static-portfolio-origin"
  region = var.aws_region

  tags = {
    Name        = "My S3 Bucket"
    Environment = "Production"
  }
}

//Upload index.html file to the S3 bucket
resource "aws_s3_object" "index_file" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "index.html"
  source = "index.html"
  content_type = "text/html"
}

//Block Public Access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "my_bucket_public_access_block" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

//iam policy to allow CloudFront to read from the S3 bucket, with a condition that only allows access from the specific CloudFront distribution ARN.
//aws_iam_policy_document data source container that dynamically injects the CloudFront distribution ARN property string at deployment runtime
data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.my_bucket.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.my_distribution.arn]
    }
  }
}


//injects the generated policy document into the S3 bucket policy
resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}