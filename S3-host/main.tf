provider "aws" {
  region = "ap-south-1" # Or your region
}

variable "aws_region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "index_html_path" {
  type = string
  description = "Path to the index.html file"
}

resource "aws_s3_bucket" "static_website" {
  bucket = "bucket-trfm" # Replace with a unique name
}

resource "aws_s3_bucket_public_access_block" "static_website_access" {
  bucket = aws_s3_bucket.static_website.bucket

  block_public_acls       = false # Required for ACLs to work
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "static_website_acl" {
  bucket = aws_s3_bucket.static_website.bucket
  acl    = "public-read" # Often not necessary, object ACLs are what matters
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
  source = var.index_html_path # Use the variable for the path
  acl    = "public-read"
  content_type = "text/html"
}

output "website_url" {
  value = "http://${aws_s3_bucket.static_website.bucket}.s3-website-${var.aws_region}.amazonaws.com"
}