locals {
  region_name                 = data.aws_region.this.name
  total_instances             = 1 + var.reader_count
  port                        = var.engine == "aurora-postgresql" ? 5432 : 3306
  cluster_deletion_protection = var.env == "prod" ? true : var.cluster_deletion_protection
  cluster_skip_final_snapshot = var.env == "prod" ? false : var.cluster_skip_final_snapshot
  encrypt_cluster             = var.contains_pii_data ? true : var.encrypt_cluster
  tags = merge(var.extra_tags, {
    Cluster   = var.name
    Env       = var.env
    ManagedBy = "terraform"
    Module    = "aws_rds_cluster"
  })
}