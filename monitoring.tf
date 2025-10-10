resource "aws_iam_role" "this" {
  name               = "${var.name}-monitoring-${local.region_name}"
  description        = "Monitoring role for RDS cluster (${var.name})"
  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role_policy.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = data.aws_iam_policy.cluster_role_policy.arn
  role       = aws_iam_role.this.name
}