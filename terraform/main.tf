# Standardized S3 Bucket for PPRO Developer Enablement

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1" # Munich/Frankfurt region where PPRO operates
}

# Create a Secure S3 Bucket for Developer App Data
resource "aws_s3_bucket" "dev_enablement_bucket" {
  lifecycle {
  prevent_destroy = true
}
  bucket = "ppro-paved-path-assets-2026"

  tags = {
    Name        = "Developer Enablement"
    Environment = "Production"
    ManagedBy   = "Infrastructure-Engineer"
  }
}

# Enforce Encryption - Essential for PCI/DORA Compliance
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.dev_enablement_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block Public Access - Security Best Practice
resource "aws_s3_bucket_public_access_block" "security_policy" {
  bucket = aws_s3_bucket.dev_enablement_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
