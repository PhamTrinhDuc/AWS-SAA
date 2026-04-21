# -------------------------------------------
# 1. S3 Bucket
# -------------------------------------------
resource "aws_s3_bucket" "this" {
  bucket = "${var.project_name}-${var.environment}-${random_id.suffix.hex}"
  tags   = var.common_tags
}

# Random suffix để tránh trùng tên bucket (globally unique)
resource "random_id" "suffix" {
  byte_length = 4
}

# -------------------------------------------
# 2. Block public access (best practice)
# -------------------------------------------
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = var.block_public_access
  block_public_policy     = var.block_public_access
  ignore_public_acls      = var.block_public_access
  restrict_public_buckets = var.block_public_access
}

# -------------------------------------------
# 3. Versioning
# -------------------------------------------
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

# -------------------------------------------
# 4. Server-side encryption (AES256 mặc định)
# -------------------------------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# -------------------------------------------
# 5. Static website hosting (tuỳ chọn)
# -------------------------------------------
resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  count  = var.enable_website ? 1 : 0

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# -------------------------------------------
# 6. Bucket policy — public read (chỉ khi enable_website)
# -------------------------------------------
resource "aws_s3_bucket_policy" "public_read" {
  count  = var.enable_website ? 1 : 0
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17" // version của policy
    Statement = [
      {
        Sid       = "PublicReadGetObject"         // tên của statement
        Effect    = "Allow"                       // cho phép
        Principal = "*"                           // tất cả mọi người
        Action    = "s3:GetObject"                // đọc file
        Resource  = "${aws_s3_bucket.this.arn}/*" // tất cả file trong bucket
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.this] // đợi public access block được tạo xong mới tạo policy
}

# -------------------------------------------
# 7. Upload file mẫu (chỉ khi enable_website)
# -------------------------------------------
resource "aws_s3_object" "index" {
  count        = var.enable_website ? 1 : 0
  bucket       = aws_s3_bucket.this.id
  key          = "index.html"
  content_type = "text/html"

  content = <<-EOF
    <!DOCTYPE html>
    <html>
      <body>
        <h1>Hello from S3 Static Website!</h1>
        <p>Bucket: ${aws_s3_bucket.this.id}</p>
      </body>
    </html>
  EOF
}
