# Un semplice bucket S3 con configurazione standard
# Questo file ha poche risorse e nessuna logica complessa

resource "aws_s3_bucket" "my_safe_bucket" {
  bucket = "my-unique-test-bucket-2026-03"

  tags = {
    Name        = "SafeBucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.my_safe_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
