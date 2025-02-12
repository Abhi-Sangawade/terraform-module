provider "aws" {
  region = "ap-south-1"  # Change this to your preferred region
}

# 1️⃣ Create an S3 Bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket        = "abhis-staticweb"  
  force_destroy = true  
}

# 2️⃣ Configure S3 for Static Website Hosting
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# 3️⃣ Allow Public Access to the Bucket
resource "aws_s3_bucket_policy" "public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })
}

# 4️⃣ Upload Website Files from "website-files/" Folder
resource "aws_s3_object" "my_website" {
  for_each = fileset("my-website/", "**")

  bucket       = aws_s3_bucket.website_bucket.id
  key          = each.value
  source       = "my-website/${each.value}"
  content_type = lookup(
    {
      "html" = "text/html"
      "css"  = "text/css"
      "js"   = "application/javascript"
    }, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream"
  )
}

# 5️⃣ Output the Website URL
output "website_url" {
  value = "http://${aws_s3_bucket_website_configuration.website_config.website_endpoint}"
}
