data "aws_caller_identity" "current" {}

data "aws_region" "this" {}

data "aws_iam_policy" "cluster_role_policy" { arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole" }

data "aws_iam_policy_document" "cluster_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}
