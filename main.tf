# Buckets.
resource "aws_s3_bucket" "frontend" {
  bucket        = var.bucket_name
  acl           = "private"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = aws_s3_bucket.frontend_logs.id
    target_prefix = "log/"
  }

  tags = var.tags
  #checkov:skip=CKV_AWS_21:Ensure all data stored in the S3 bucket have versioning enabled.
  #checkov:skip=CKV_AWS_52:Ensure S3 bucket has MFA delete enabled
}

resource "aws_s3_bucket" "frontend_logs" {
  bucket        = "${var.bucket_name}-logs"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.s3.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle_rule {
    id      = "log"
    enabled = true

    prefix = "log/"

    tags = {
      rule      = "log"
      autoclean = "true"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 90
    }
  }

  tags = var.tags
  #checkov:skip=CKV_AWS_18:Ensure the S3 bucket has access logging enabled.
  #checkov:skip=CKV_AWS_52:Ensure S3 bucket has MFA delete enabled
}


# Policies.
resource "aws_s3_bucket_policy" "frontend_s3_policy" {
  bucket = aws_s3_bucket.frontend.id
  policy = data.aws_iam_policy_document.public_read_get_object.json
}

resource "aws_s3_bucket_public_access_block" "frontend_s3_access" {
  bucket                  = aws_s3_bucket.frontend.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
