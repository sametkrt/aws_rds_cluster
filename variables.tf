variable "env" {
  type        = string
  description = "(Required) Environment name."
}

variable "name" {
  type        = string
  description = "(Optional) Name prefix used across resources."
  default     = null
}

variable "vpc_id" {
  type        = string
  description = "(Required) VPC ID where the Aurora cluster will be deployed."
}

variable "subnet_ids" {
  type        = list(string)
  description = "(Required) List of existing subnet IDs where the database instances will be launched."

  validation {
    condition     = length(var.subnet_ids) > 1 && length(distinct(var.subnet_ids)) > 1
    error_message = "[ERROR] Please specify at least 2 unique subnets."
  }
}

variable "cluster_allowed_ingress_cidrs" {
  type        = list(string)
  description = "(Optional) List of CIDR ranges allowed for inbound DB traffic."
  default     = []
}

variable "security_groups" {
  description = "(Optional) Security group IDs allowed to connect to the Aurora cluster."
  type        = list(string)
  default     = []
}

variable "cluster_parameter_group_family" {
  type        = string
  description = "(Optional) Parameter group family name."
  default     = "aurora-postgresql15"
}

variable "cluster_parameter_group_values" {
  type        = list(map(string))
  description = "(Optional) List of maps containing cluster parameter group settings."
  default     = []
}

variable "db_parameter_group_values" {
  type        = list(map(string))
  description = "(Optional) List of maps containing instance-level parameter group settings."
  default     = []
}

variable "engine" {
  description = "(Optional) Aurora engine type. One of: aurora, aurora-mysql, aurora-postgresql."
  type        = string
  default     = "aurora-postgresql"
  validation {
    condition     = contains(["aurora", "aurora-mysql", "aurora-postgresql"], var.engine)
    error_message = "[ERROR] Valid values are: aurora, aurora-mysql, aurora-postgresql."
  }
}

variable "cluster_engine_version" {
  description = "(Optional) Aurora engine version (e.g., 15.4 for PostgreSQL or 8.0.mysql_aurora.3.10.0 for MySQL)."
  type        = string
  default     = null
}

variable "cluster_master_username" {
  type        = string
  description = "(Required) Master username for the Aurora cluster."
}

variable "cluster_snapshot_identifier" {
  type        = string
  description = "(Optional) Snapshot name or ARN to restore the cluster from."
  default     = null
}

variable "cluster_skip_final_snapshot" {
  type        = bool
  description = "(Optional) Determines whether a final DB snapshot is created before the DB cluster gets deleted."
  default     = false
}

variable "cluster_publicly_accessible" {
  type        = bool
  description = "(Optional) Whether DB instances should be publicly accessible."
  default     = false
}

variable "backup_retention_period" {
  description = "(Optional) Number of days to retain automated backups. Set to 0 to disable backups."
  type        = number
  default     = 1
}

variable "cluster_deletion_protection" {
  description = "(Optional) Whether to enable deletion protection on the cluster."
  type        = bool
  default     = true
}

variable "storage_encrypted" {
  description = "(Optional) Whether to enable storage-level encryption for the Aurora cluster."
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "(Optional) Whether modifications are applied immediately or during the next maintenance window."
  type        = bool
  default     = true
}

variable "instance_class" {
  description = "(Optional) DB instance class for writer and reader instances."
  type        = string
  default     = "db.r6g.large"
}

variable "reader_count" {
  description = "(Optional) Number of reader instances to create in addition to the writer."
  type        = number
  default     = 0
}

variable "cluster_cloudwatch_logs_exports" {
  type        = list(string)
  description = "(Optional) The list of log types that need to be enabled for exporting to CloudWatch."
  default     = ["postgresql"]
}

variable "performance_insights_enabled" {
  description = "(Optional) Enable Performance Insights on Aurora instances."
  type        = bool
  default     = true
}

variable "performance_insights_retention_period" {
  description = "(Optional) Number of days to retain Performance Insights data (7 or 731)."
  type        = number
  default     = 7
}

variable "performance_insights_kms_key_id" {
  description = "(Optional) KMS key ID to encrypt Performance Insights data. Defaults to AWS-managed key if null."
  type        = string
  default     = null
}

variable "instance_promotion_tier" {
  description = "(Optional) Failover priority tier for Aurora instances. Lower numbers have higher priority for promotion to writer during failover (0–15)."
  type        = number
  default     = 0
}

variable "encrypt_cluster" {
  type        = bool
  description = "(Optional) Bool used to enable/disable Aurora cluster storage encryption."
  default     = false
}

variable "contains_pii_data" {
  type        = bool
  description = "(Optional) Bool used to include CloudWatch audit log exports for cluster with PII data."
  default     = false
}

variable "extra_tags" {
  description = "(Optional) Map of tags to apply to all created resources."
  type        = map(string)
  default     = {}
}
 