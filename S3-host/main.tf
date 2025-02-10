provider "aws" {
  region = "ap-south-1"  # Change region if needed
}

# Declare the aws_region variable (if not using default)
variable "aws_region" {
  description = "The AWS region where resources will be created."
  default     = "ap-south-1"  # You can modify this region if needed
}

# Create an S3 bucket
resource "aws_s3_bucket" "static_website" {
  bucket = "trfm-bucket-15243"  # Use a unique bucket name
}

# Disable block public access for the S3 bucket
resource "aws_s3_bucket_public_access_block" "static_website_access" {
  bucket = aws_s3_bucket.static_website.id

  block_public_acls   = false
  block_public_policy = false
}

# Configure the S3 bucket as a static website
resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }

  # Optional: Define error document (e.g., 404.html)
  error_document {
    key = "error.html"
  }
}

# Upload the website files (index.html in this case)
resource "aws_s3_object" "website_index" {
  bucket = aws_s3_bucket.static_website.id
  key    = "index.html"
  source = "index.html"  # Replace with your local file path
  acl    = "public-read"  # Allow public access to the file
}

# Set the bucket ACL using a separate resource
resource "aws_s3_bucket_acl" "static_website_acl" {
  bucket = aws_s3_bucket.static_website.id
  acl    = "public-read"  # Set the bucket ACL to public-read
}

# Output the URL of the static website
output "website_url" {
  value = "http://${aws_s3_bucket.static_website.bucket}.s3-website-${var.aws_region}.amazonaws.com"
}
