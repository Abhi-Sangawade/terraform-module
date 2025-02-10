provider "aws" {
  region = "ap-south-1"
}

variable "aws_region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "index_html_path" {
  type = string
  description = "Path to the index.html file"
  default = "index.html"
}

resource "aws_s3_bucket" "static_website" {
  bucket = "bucket-trfm-1" # Or a unique name
}

resource "aws_s3_bucket_public_access_block" "static_website_access" {
  bucket = aws_s3_bucket.static_website.bucket

  block_public_acls       = false # Important, but not strictly required for bucket policy
  block_public_policy     = false # Important, but not strictly required for bucket policy
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "static_website_policy" {
  bucket = aws_s3_bucket.static_website.bucket
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "PublicReadGetObject"
        Effect = "Allow"
        Principal = "*" # Allow everyone to read
        Action   = [
          "s3:GetObject"
        ]
        Resource = [
          aws_s3_bucket.static_website.arn,
          "${aws_s3_bucket.static_website.arn}/*" # Important: Include objects
        ]
      }
    ]
  })
}


resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.static_website.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html" # Optional
  }
}

resource "aws_s3_object" "website_index" {
  bucket = aws_s3_bucket.static_website.bucket
  key    = "index.html"
  source = var.index_html_path
  content_type = "text/html" # Important: Set content type
}

output "website_url" {
  value = "http://${aws_s3_bucket.static_website.bucket}.s3-website-${var.aws_region}.amazonaws.com"
}