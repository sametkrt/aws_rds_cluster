output "endpoint" {
  value = aws_rds_cluster.this.endpoint
}

output "reader_endpoint" {
  value = var.reader_count > 0 ? aws_rds_cluster.this.reader_endpoint : null
}

output "security_group_id" {
  value = aws_security_group.this.id
}

# DMS
output "dms_parameter_group_name" {
  value       = try(aws_rds_cluster_parameter_group.this_dms[0].name, null)
  description = "Cluster parameter group enabling logical replication for DMS"
}
