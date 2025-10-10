resource "aws_rds_cluster" "this" {
  cluster_identifier              = var.name
  engine                          = var.engine
  engine_version                  = var.cluster_engine_version
  port                            = local.port
  db_subnet_group_name            = aws_db_subnet_group.this.name
  vpc_security_group_ids          = [aws_security_group.this.id]
  backup_retention_period         = var.backup_retention_period
  deletion_protection             = local.cluster_deletion_protection
  storage_encrypted               = var.storage_encrypted
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.name
  apply_immediately               = var.apply_immediately
  master_username                 = var.cluster_master_username
  master_password                 = sensitive(random_password.this.result)
  skip_final_snapshot             = local.cluster_skip_final_snapshot
  enabled_cloudwatch_logs_exports = var.cluster_cloudwatch_logs_exports

  tags = local.tags
}

resource "aws_rds_cluster_instance" "this" {
  count = local.total_instances

  cluster_identifier                    = aws_rds_cluster.this.id
  identifier                            = "${var.name}-${count.index + 1}"
  instance_class                        = var.instance_class
  engine                                = aws_rds_cluster.this.engine
  engine_version                        = aws_rds_cluster.this.engine_version
  publicly_accessible                   = var.cluster_publicly_accessible
  db_parameter_group_name               = aws_db_parameter_group.this.name
  apply_immediately                     = var.apply_immediately
  promotion_tier                        = var.instance_promotion_tier
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null

  tags = local.tags
}

resource "aws_rds_cluster_parameter_group" "this" {
  name        = "${var.name}-cluster-pgroup"
  description = "${var.name} cluster parameter group"
  family      = var.cluster_parameter_group_family

  dynamic "parameter" {
    for_each = var.cluster_parameter_group_values
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", "pending-reboot")
    }
  }

  tags = local.tags
}

resource "aws_db_parameter_group" "this" {
  name        = "${var.name}-db-pgroup"
  description = "${var.name} database parameter group"
  family      = var.cluster_parameter_group_family

  dynamic "parameter" {
    for_each = var.db_parameter_group_values
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", "pending-reboot")
    }
  }

  tags = local.tags
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids
  tags       = merge(local.tags, { Name = "${var.name}-db-subnet-group" })
}