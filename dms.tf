resource "aws_rds_cluster_parameter_group" "this_dms" {
  count      = var.enable_dms_source ? 1 : 0
  name       = "${var.name}-dms-apg"
  family     = var.cluster_engine_version != null ? "aurora-postgresql${replace(var.cluster_engine_version, "/\\..*/", "")}" : "aurora-postgresql14"
  description = "Params for DMS CDC: logical replication"

  parameter {
    name  = "rds.logical_replication"
    value = "1"
  }

  parameter {
    name  = "max_replication_slots"
    value = tostring(var.dms_max_replication_slots)
  }

  parameter {
    name  = "max_wal_senders"
    value = tostring(var.dms_max_wal_senders)
  }

  parameter {
    name  = "max_logical_replication_workers"
    value = tostring(var.dms_max_logical_replication_workers)
  }

  dynamic "parameter" {
    for_each = var.dms_max_worker_processes == null ? [] : [1]
    content {
      name  = "max_worker_processes"
      value = tostring(var.dms_max_worker_processes)
    }
  }
}

resource "aws_db_parameter_group" "this_dms" {
  count       = var.enable_dms_source && var.engine == "postgres" ? 1 : 0
  name        = "${var.name}-dms-rds-pg"
  family      = cluster_engine_version
  description = "Params for DMS: logical replication"

  parameter {
    name  = "rds.logical_replication"
    value = "1"
  }
  parameter {
    name  = "max_replication_slots"
    value = tostring(var.dms_max_replication_slots)
  }
  parameter {
    name  = "max_wal_senders"
    value = tostring(var.dms_max_wal_senders)
  }
  parameter {
    name  = "max_logical_replication_workers"
    value = tostring(var.dms_max_logical_replication_workers)
  }
  dynamic "parameter" {
    for_each = var.dms_max_worker_processes == null ? [] : [1]
    content {
      name  = "max_worker_processes"
      value = tostring(var.dms_max_worker_processes)
    }
  }
}

resource "aws_security_group_rule" "dms_ingress" {
  for_each                 = toset(var.dms_allowed_security_group_ids)
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.this.id
  source_security_group_id = each.value
  description              = "Allow DMS replication instance to connect"
}