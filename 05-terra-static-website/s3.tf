resource "random_id" "random" {
  byte_length = 4
}


resource "aws_s3_bucket" "bucket" {
  bucket = "kyriakos-kardabikis-${random_id.random.hex}"
}

resource "aws_s3_bucket_public_access_block" "public_website" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_website_read" {
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Sid       = "PublicRead"
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.bucket.arn}/*"
    }]
  })
}

resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.bucket.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.bucket.id
  key          = "index.html"
  source       = "files/homepage.html"
  etag         = filemd5("files/homepage.html")
  content_type = "text/html"
}

resource "aws_s3_object" "error_html" {
  bucket       = aws_s3_bucket.bucket.id
  key          = "error.html"
  source       = "files/error.html"
  etag         = filemd5("files/error.html")
  content_type = "text/html"
}