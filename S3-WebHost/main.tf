provider "aws" {
  region = "ap-south-1"  
}

# 1️⃣ Create an S3 Bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket        = "abhis-staticweb"  
  force_destroy = true  
}

# 2️⃣ Allow Public Access by Disabling Block Public Access
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.website_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 3️⃣ Configure S3 for Static Website Hosting
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# 4️⃣ Set Bucket Policy to Allow Public Access
resource "aws_s3_bucket_policy" "public_access" {
  depends_on = [aws_s3_bucket_public_access_block.public_access]  # Ensure public access settings are disabled first
  bucket     = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })
}

# 5️⃣ Upload Website Files from "website-files/" Folder
resource "aws_s3_object" "my_website" {
  for_each = fileset("website-files/", "**")

  bucket       = aws_s3_bucket.website_bucket.id
  key          = each.value
  source       = "website-files/${each.value}"
  content_type = lookup(
    {
      "html" = "text/html"
      "css"  = "text/css"
      "js"   = "application/javascript"
    }, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream"
  )
}

# 6️⃣ Output the Website URL
output "website_url" {
  value = "http://${aws_s3_bucket_website_configuration.website_config.website_endpoint}"
}
