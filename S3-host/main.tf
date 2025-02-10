provider "aws" {
  region = "ap-south-1"  # You can change the region if needed
}

# Declare the aws_region variable (if not using default)
variable "aws_region" {
  description = "The AWS region where resources will be created."
  default     = "ap-south-1"  # You can modify this region if needed
}

# Create an S3 bucket
resource "aws_s3_bucket" "static_website" {
  bucket = "trfm-bucket"  # Replace with a unique name
}

# Configure the S3 bucket as a static website
resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.static_website.bucket

  index_document {
    suffix = "index.html"
  }
}
resource "aws_s3_object" "website_index" {
  bucket = aws_s3_bucket.static_website.bucket
  key    = "index.html"
  source = "index.html"  
  acl    = "public-read" 
}

output "website_url" {
  value = "http://${aws_s3_bucket.static_website.bucket}.s3-website-${var.aws_region}.amazonaws.com"
}
