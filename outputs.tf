output "endpoint" {
  value = aws_rds_cluster.this.endpoint
}

output "reader_endpoint" {
  value = var.reader_count > 0 ? aws_rds_cluster.this.reader_endpoint : null
}

output "security_group_id" {
  value = aws_security_group.this.id
}