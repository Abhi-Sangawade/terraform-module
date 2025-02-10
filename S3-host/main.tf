provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "static_website" {
  bucket = "trfm-bucket"
}

resource "aws_s3_bucket_website_configuration" "static_website_config" {
  bucket = aws_s3_bucket.static_website.bucket

  index_document {
    suffix = "index.html"
  }
}

resource "null_resource" "download_and_unzip" {
  provisioner "local-exec" {
    command = <<EOT
      wget https://www.free-css.com/assets/files/free-css-templates/download/page296/listrace.zip -O /tmp/listrace.zip
      unzip /tmp/listrace.zip -d /tmp/listrace/
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "aws_s3_object" "static_files" {
  for_each = fileset("/tmp/listrace", "*")

  bucket = aws_s3_bucket.static_website.bucket
  key    = each.value
  source = "/tmp/listrace/${each.value}"
  acl    = "public-read"
}
output "website_url" {
  value = "http://${aws_s3_bucket.static_website.bucket}.s3-website-us-east-1.amazonaws.com" 
}

