resource aws_s3_bucket "s3bucket" {
    bucket = "s3-bucket-with-transitions"
    acl = "public-read"

    website {
        index_document = "index.html"
        error_document = "error.html"
    }

    versioning {
      enabled = true
    }

    lifecycle_rule {
      prefix = "Config/"
      enabled = true

      noncurrent_version_transition {
          days = 30
          storage_class = "STANDARD_IA"
      }

      noncurrent_version_transition {
          days = 60
          storage_class = "GLACIER"
      }

      noncurrent_version_expiration {
          days = 90
      }
    }
}

provider "aws" {
    region = "us-east-1"
}


resource "aws_s3_bucket_object" "root_folder" {
    for_each = fileset("website/build/", "*.html")
    bucket = aws_s3_bucket.s3bucket.id
    acl = "public-read"
    key = "${each.value}"
    content_type = "text/html"
    source = "website/build/${each.value}"
    etag = filemd5("website/build/${each.value}")
}

resource "aws_s3_bucket_object" "root_folder_png" {
    for_each = fileset("website/build/", "*.png")
    bucket = aws_s3_bucket.s3bucket.id
    acl = "public-read"
    key = "${each.value}"
    content_type =  "image/png" 
    source = "website/build/${each.value}"
    etag = filemd5("website/build/${each.value}")
}

resource "aws_s3_bucket_object" "root_folder_txt" {
    for_each = fileset("website/build/", "*.txt")
    bucket = aws_s3_bucket.s3bucket.id
    acl = "public-read"
    key = "${each.value}"
    content_type =  "text/plain" 
    source = "website/build/${each.value}"
    etag = filemd5("website/build/${each.value}")
}

resource "aws_s3_bucket_object" "css" {
    for_each = fileset("website/build/static/css/", "*")
    acl = "public-read"
    bucket = aws_s3_bucket.s3bucket.id
    content_type = "text/css"
    key = "static/css/${each.value}"
    source = "website/build/static/css/${each.value}"
    etag = filemd5("website/build/static/css/${each.value}")
}

resource "aws_s3_bucket_object" "js" {
    for_each = fileset("website/build/static/js/", "*")
    bucket = aws_s3_bucket.s3bucket.id
    key = "static/js/${each.value}"
    content_type = "text/javascript"
    acl = "public-read"
    source = "website/build/static/js/${each.value}"
    etag = filemd5("website/build/static/js/${each.value}")
}

resource "aws_s3_bucket_object" "media" {
    for_each = fileset("website/build/static/media/", "*.svg")
    bucket = aws_s3_bucket.s3bucket.id
    key = "static/media/${each.value}"
    acl = "public-read"
    content_type = "image/svg+xml"
    source = "website/build/static/media/${each.value}"
    etag = filemd5("website/build/static/media/${each.value}")
}