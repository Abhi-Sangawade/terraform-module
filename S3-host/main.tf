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
  bucket = "bucket-trfm-2" 
}

# Object Ownership: CRITICAL for ACLs to work when other accounts own objects
resource "aws_s3_bucket_ownership_controls" "ownership_controls" {
  bucket = aws_s3_bucket.static_website.bucket
  rule {
    object_ownership = "BucketOwnerPreferred" # Important: Allows ACLs
  }
}

resource "aws_s3_bucket_public_access_block" "static_website_access" {
  bucket = aws_s3_bucket.static_website.bucket

  block_public_acls       = false # Required for ACLs
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "static_website_acl" {
  bucket = aws_s3_bucket.static_website.bucket
  acl    = "public-read" # Often not necessary, object ACLs are what matters
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership_controls
  ]
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
  acl    = "public-read"
  content_type = "text/html"
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership_controls
  ]
}

output "website_url" {
  value = "http://${aws_s3_bucket.static_website.bucket}.s3-website-${var.aws_region}.amazonaws.com"
}