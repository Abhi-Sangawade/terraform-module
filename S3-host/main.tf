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

variable "assets_path" {
  type = string
  description = "Path to the assets folder"
  default = "./assets"  # Default assets folder in the same directory
}

resource "aws_s3_bucket" "static_website" {
  bucket = "bucket-trfm-1" # Or a unique name
}

resource "aws_s3_bucket_ownership_controls" "ownership_controls" {
  bucket = aws_s3_bucket.static_website.bucket
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "static_website_access" {
  bucket = aws_s3_bucket.static_website.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "static_website_acl" {
  bucket = aws_s3_bucket.static_website.bucket
  acl    = "public-read"
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

resource "aws_s3_object" "website_assets" {
  for_each = fileset(var.assets_path, "**/*")

  bucket = aws_s3_bucket.static_website.bucket
  key    = each.key
  source = "${var.assets_path}/${each.key}"
  acl    = "public-read"

  content_type = (
    can(regex("\\.([a-zA-Z0-9-]+)$", each.key)[1]) ? (
      lookup({
        "css" : "text/css",
        "js" : "application/javascript",
        "html" : "text/html",
        "png" : "image/png",
        "jpg" : "image/jpeg",
        "jpeg" : "image/jpeg",
        "gif" : "image/gif",
        "svg" : "image/svg+xml",
        "ico" : "image/x-icon",
        "woff": "font/woff",
        "woff2": "font/woff2"
      }, lower(regex("\\.([a-zA-Z0-9-]+)$", each.key)[1]), "application/octet-stream")
    ) : "application/octet-stream"
  )

  depends_on = [
    aws_s3_bucket_ownership_controls.ownership_controls
  ]
}

output "website_url" {
  value = "http://${aws_s3_bucket.static_website.bucket}.s3-website-${var.aws_region}.amazonaws.com"
}