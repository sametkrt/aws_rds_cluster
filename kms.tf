resource "aws_kms_key" "this" {
  count = local.encrypt_cluster ? 1 : 0

  description              = "KMS symetric key used for encrypting/decrypting RDS cluster (${var.name})"
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = true

  tags = local.tags
}

resource "aws_kms_alias" "this" {
  count = local.encrypt_cluster ? 1 : 0

  name          = "alias/${var.name}-db-key"
  target_key_id = aws_kms_key.this[0].id
}