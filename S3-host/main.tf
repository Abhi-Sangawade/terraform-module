provider "aws" {
  region = "ap-south-1"  
}

resource "aws_s3_bucket" "static_website" {
  bucket = "trfm-bucket"  


  website {
    index_document = "index.html"
  
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
