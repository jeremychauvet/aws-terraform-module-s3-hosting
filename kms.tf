resource "aws_kms_key" "s3" {
  description             = "S3 KMS key"
  deletion_window_in_days = 15
  enable_key_rotation     = true
  tags                    = var.tags
}
