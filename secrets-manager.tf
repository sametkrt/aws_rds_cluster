resource "random_password" "this" {
  length           = 30
  override_special = "!#$()-_=+?"
  special          = true
}

resource "aws_secretsmanager_secret" "this" {
  name                    = aws_rds_cluster.this.cluster_identifier
  description             = "RDS cluster (${var.name}) master password"
  recovery_window_in_days = 0

  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = sensitive(random_password.this.result)
}